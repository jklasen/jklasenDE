"""Reads events from macOS Calendar.app via EventKit.

EventKit auth is implicit through macOS – no password handling here.
Recurring events are returned as expanded individual occurrences via
predicateForEventsWithStartDate:endDate:calendars:.
"""
from __future__ import annotations

import logging
import sys
import threading
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Optional

log = logging.getLogger(__name__)


@dataclass
class ExchangeEvent:
    uid: str                    # stable EventKit identifier
    title: str
    start: datetime
    end: datetime
    all_day: bool
    location: Optional[str]
    notes: Optional[str]
    attendee_names: list[str]
    status: str                 # "confirmed" | "tentative" | "cancelled" | "none"
    availability: str           # "busy" | "free" | "tentative" | "unavailable"
    timezone_name: Optional[str]
    calendar_title: Optional[str]


def _import_eventkit():
    try:
        import EventKit  # type: ignore
        from Foundation import NSDate  # type: ignore
        return EventKit, NSDate
    except ImportError as e:
        raise RuntimeError(
            "EventKit / Foundation are not available. Install pyobjc-framework-EventKit "
            "and run on macOS."
        ) from e


def ensure_authorization() -> None:
    """Block until Calendar access is granted, or raise if denied."""
    EventKit, _ = _import_eventkit()

    EKEventStore = EventKit.EKEventStore
    EKEntityTypeEvent = 0  # EKEntityTypeEvent

    status = EKEventStore.authorizationStatusForEntityType_(EKEntityTypeEvent)
    # 0 = notDetermined, 1 = restricted, 2 = denied, 3 = authorized,
    # 4 = writeOnly (macOS 14+), 5 = fullAccess (macOS 14+ EK)
    AUTHORIZED = {3, 5}
    DENIED = {1, 2}

    if status in AUTHORIZED:
        return

    if status in DENIED:
        raise PermissionError(
            "Calendar-Zugriff verweigert. Aktiviere Zugriff für den python-Binary "
            "unter Systemeinstellungen → Datenschutz & Sicherheit → Kalender."
        )

    # notDetermined: trigger the prompt and wait
    store = EKEventStore.alloc().init()
    done = threading.Event()
    result = {"granted": False, "error": None}

    def handler(granted, error):
        result["granted"] = bool(granted)
        result["error"] = error
        done.set()

    if hasattr(store, "requestFullAccessToEventsWithCompletion_"):
        store.requestFullAccessToEventsWithCompletion_(handler)
    else:
        store.requestAccessToEntityType_completion_(EKEntityTypeEvent, handler)

    if not done.wait(timeout=120):
        raise PermissionError("Timeout beim Warten auf Calendar-Zugriffsdialog.")
    if not result["granted"]:
        raise PermissionError(
            f"Calendar-Zugriff nicht gewährt: {result['error']}. "
            "Bitte unter Systemeinstellungen → Datenschutz & Sicherheit → Kalender freigeben."
        )


def _ns_date_from_datetime(dt: datetime):
    _, NSDate = _import_eventkit()
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return NSDate.dateWithTimeIntervalSince1970_(dt.timestamp())


def _datetime_from_ns_date(ns_date) -> Optional[datetime]:
    if ns_date is None:
        return None
    ts = ns_date.timeIntervalSince1970()
    return datetime.fromtimestamp(ts, tz=timezone.utc)


_STATUS_MAP = {
    0: "none",
    1: "confirmed",
    2: "tentative",
    3: "cancelled",
}

_AVAIL_MAP = {
    0: "busy",       # notSupported – treat as busy by default
    1: "busy",
    2: "free",
    3: "tentative",
    4: "unavailable",
}


def fetch_events(
    account_name: str,
    calendar_filter: list[str],
    window_start: datetime,
    window_end: datetime,
) -> list[ExchangeEvent]:
    EventKit, _ = _import_eventkit()

    store = EventKit.EKEventStore.alloc().init()

    all_calendars = store.calendarsForEntityType_(0)
    selected = []
    for cal in all_calendars:
        source = cal.source()
        source_title = str(source.title()) if source else ""
        cal_title = str(cal.title())
        if source_title != account_name:
            continue
        if calendar_filter and cal_title not in calendar_filter:
            continue
        selected.append(cal)

    if not selected:
        log.warning(
            "Kein Kalender im Account '%s' gefunden (Filter: %s). "
            "Verfügbare Sources: %s",
            account_name,
            calendar_filter,
            sorted({str(c.source().title()) for c in all_calendars if c.source()}),
        )
        return []

    log.info("Lese aus %d Kalender(n) im Account '%s'", len(selected), account_name)

    predicate = store.predicateForEventsWithStartDate_endDate_calendars_(
        _ns_date_from_datetime(window_start),
        _ns_date_from_datetime(window_end),
        selected,
    )
    raw_events = store.eventsMatchingPredicate_(predicate) or []

    out: list[ExchangeEvent] = []
    for ek in raw_events:
        try:
            uid = str(ek.calendarItemIdentifier())
        except Exception:
            uid = str(ek.eventIdentifier())

        start = _datetime_from_ns_date(ek.startDate())
        end = _datetime_from_ns_date(ek.endDate())
        if not start or not end:
            continue

        all_day = bool(ek.isAllDay())
        title = str(ek.title()) if ek.title() else "(ohne Titel)"
        location = str(ek.location()) if ek.location() else None
        notes = str(ek.notes()) if ek.notes() else None

        attendee_names: list[str] = []
        attendees = ek.attendees() or []
        for a in attendees:
            try:
                name = a.name()
                if name:
                    attendee_names.append(str(name))
                    continue
            except Exception:
                pass
            try:
                url = a.URL()
                if url:
                    attendee_names.append(str(url).replace("mailto:", ""))
            except Exception:
                continue

        status_int = int(ek.status()) if ek.status() is not None else 0
        avail_int = int(ek.availability()) if ek.availability() is not None else 0

        tz_name = None
        try:
            tz = ek.timeZone()
            if tz:
                tz_name = str(tz.name())
        except Exception:
            pass

        cal_title = None
        try:
            cal_title = str(ek.calendar().title())
        except Exception:
            pass

        out.append(
            ExchangeEvent(
                uid=uid,
                title=title,
                start=start,
                end=end,
                all_day=all_day,
                location=location,
                notes=notes,
                attendee_names=attendee_names,
                status=_STATUS_MAP.get(status_int, "none"),
                availability=_AVAIL_MAP.get(avail_int, "busy"),
                timezone_name=tz_name,
                calendar_title=cal_title,
            )
        )

    log.info("EventKit lieferte %d Events im Fenster", len(out))
    return out


def list_calendars(account_name: Optional[str] = None) -> list[tuple[str, str]]:
    """Diagnostic helper: returns (source_title, calendar_title) tuples."""
    EventKit, _ = _import_eventkit()
    store = EventKit.EKEventStore.alloc().init()
    out = []
    for cal in store.calendarsForEntityType_(0) or []:
        src = cal.source()
        src_title = str(src.title()) if src else ""
        if account_name and src_title != account_name:
            continue
        out.append((src_title, str(cal.title())))
    return out


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    ensure_authorization()
    for src, cal in list_calendars():
        print(f"{src}\t{cal}", file=sys.stdout)
