"""Convert ExchangeEvent → Google Calendar event body + content hash."""
from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
from typing import Any

from .eventkit_reader import ExchangeEvent


def _iso(dt: datetime) -> str:
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.isoformat()


def content_hash(event: ExchangeEvent, mode: str) -> str:
    payload = {
        "title": event.title,
        "start": _iso(event.start),
        "end": _iso(event.end),
        "all_day": event.all_day,
        "location": event.location or "",
        "notes": event.notes or "",
        "attendees": sorted(event.attendee_names),
        "status": event.status,
        "availability": event.availability,
        "tz": event.timezone_name or "",
        "mode": mode,
    }
    blob = json.dumps(payload, sort_keys=True, ensure_ascii=False).encode("utf-8")
    return hashlib.sha256(blob).hexdigest()


def _build_description(event: ExchangeEvent, attendees_as_description: bool) -> str:
    parts: list[str] = []
    if event.notes:
        parts.append(event.notes.strip())
    if attendees_as_description and event.attendee_names:
        names = "\n".join(f"- {n}" for n in event.attendee_names)
        parts.append(f"Teilnehmer:\n{names}")
    return "\n\n".join(parts) if parts else ""


def to_google_event(
    event: ExchangeEvent,
    *,
    mode: str,
    attendees_as_description: bool,
    busy_title: str = "CID-Termin",
) -> dict[str, Any]:
    if mode == "busy":
        summary = busy_title
        description = ""
        location = None
    else:
        summary = event.title
        description = _build_description(event, attendees_as_description)
        location = event.location

    body: dict[str, Any] = {
        "summary": summary,
        "extendedProperties": {
            "private": {
                "exchangeUid": event.uid,
                "syncSource": "exchange-google-sync",
            }
        },
        # Belt-and-suspenders against accidental invites:
        # explicitly empty attendees list is rejected by API, so we just omit the key.
        "transparency": "opaque" if event.availability != "free" else "transparent",
        "status": "cancelled" if event.status == "cancelled" else "confirmed",
    }

    if description:
        body["description"] = description
    if location:
        body["location"] = location

    if event.all_day:
        body["start"] = {"date": event.start.date().isoformat()}
        body["end"] = {"date": event.end.date().isoformat()}
    else:
        start_block: dict[str, str] = {"dateTime": _iso(event.start)}
        end_block: dict[str, str] = {"dateTime": _iso(event.end)}
        if event.timezone_name:
            start_block["timeZone"] = event.timezone_name
            end_block["timeZone"] = event.timezone_name
        body["start"] = start_block
        body["end"] = end_block

    return body
