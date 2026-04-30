#!/usr/bin/env python3
"""Main entry point: one-way sync Exchange (Calendar.app) → Google Calendar."""
from __future__ import annotations

import logging
import logging.handlers
import sys
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path

import yaml

from lib.eventkit_reader import ExchangeEvent, ensure_authorization, fetch_events
from lib.google_writer import GoogleWriter
from lib.state import State
from lib.transform import content_hash, to_google_event

CONFIG_DIR = Path("~/.config/exchange-google-sync").expanduser()
TOKEN_FILE = CONFIG_DIR / "token.json"
STATE_DB = CONFIG_DIR / "state.db"
DEFAULT_CONFIG_PATH = Path(__file__).resolve().parent / "config.yaml"


def setup_logging(path: str, level: str) -> None:
    log_path = Path(path).expanduser()
    log_path.parent.mkdir(parents=True, exist_ok=True)
    handler = logging.handlers.RotatingFileHandler(
        log_path, maxBytes=2_000_000, backupCount=5, encoding="utf-8"
    )
    handler.setFormatter(
        logging.Formatter("%(asctime)s %(levelname)s %(name)s: %(message)s")
    )
    root = logging.getLogger()
    root.setLevel(level.upper())
    root.addHandler(handler)
    # Also stderr so launchd captures it in *.err.log
    stderr = logging.StreamHandler(sys.stderr)
    stderr.setFormatter(logging.Formatter("%(levelname)s %(name)s: %(message)s"))
    root.addHandler(stderr)


def load_config(path: Path) -> dict:
    if not path.exists():
        raise FileNotFoundError(
            f"config.yaml fehlt unter {path}. config.yaml.example kopieren und anpassen."
        )
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def _iso(dt: datetime) -> str:
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.isoformat()


def run() -> int:
    config_path = DEFAULT_CONFIG_PATH
    if len(sys.argv) > 1:
        config_path = Path(sys.argv[1]).expanduser()

    cfg = load_config(config_path)
    setup_logging(cfg["logging"]["path"], cfg["logging"].get("level", "INFO"))
    log = logging.getLogger("sync")

    started = time.monotonic()

    account_name = cfg["exchange"]["account_name"]
    calendar_filter = cfg["exchange"].get("calendars") or []
    target_calendar = cfg["google"]["target_calendar_id"]
    sync_cfg = cfg["sync"]
    mode = sync_cfg.get("mode", "full")
    attendees_as_description = sync_cfg.get("attendees_as_description", True)
    busy_title = sync_cfg.get("busy_title", "CID-Termin")

    now = datetime.now(timezone.utc)
    window_start = now - timedelta(days=int(sync_cfg.get("window_past_days", 30)))
    window_end = now + timedelta(days=int(sync_cfg.get("window_future_days", 365)))

    log.info(
        "Sync-Lauf: account=%s mode=%s window=%s..%s target=%s",
        account_name, mode, window_start.date(), window_end.date(), target_calendar,
    )

    try:
        ensure_authorization()
    except PermissionError as e:
        log.error(str(e))
        return 2

    events = fetch_events(account_name, calendar_filter, window_start, window_end)

    state = State(STATE_DB)
    writer = GoogleWriter(TOKEN_FILE, target_calendar)

    created = updated = deleted = skipped = errors = 0
    seen_uids: set[str] = set()

    for ev in events:
        seen_uids.add(ev.uid)
        try:
            if ev.status == "cancelled":
                mapping = state.get(ev.uid)
                if mapping:
                    if writer.delete(mapping["google_event_id"]):
                        state.delete(ev.uid)
                        deleted += 1
                continue

            new_hash = content_hash(ev, mode)
            mapping = state.get(ev.uid)

            # Recover orphan mapping via extendedProperty if SQLite was lost
            if not mapping:
                existing = writer.find_by_exchange_uid(ev.uid)
                if existing:
                    mapping = {
                        "google_event_id": existing["id"],
                        "content_hash": "",
                        "last_start": _iso(ev.start),
                    }

            body = to_google_event(
                ev,
                mode=mode,
                attendees_as_description=attendees_as_description,
                busy_title=busy_title,
            )

            if mapping is None:
                result = writer.insert(body)
                state.upsert(ev.uid, result["id"], new_hash, _iso(ev.start))
                created += 1
            elif mapping["content_hash"] == new_hash:
                skipped += 1
            else:
                writer.patch(mapping["google_event_id"], body)
                state.upsert(ev.uid, mapping["google_event_id"], new_hash, _iso(ev.start))
                updated += 1
        except Exception:
            errors += 1
            log.exception("Fehler bei Event uid=%s title=%r", ev.uid, ev.title)

    # GC: mappings whose original start lies in the current window but which
    # are no longer visible in EventKit → event was deleted in Exchange.
    stale = state.stale_in_window(seen_uids, _iso(window_start), _iso(window_end))
    for m in stale:
        try:
            if writer.delete(m["google_event_id"]):
                state.delete(m["exchange_uid"])
                deleted += 1
        except Exception:
            errors += 1
            log.exception("Fehler beim GC von uid=%s", m["exchange_uid"])

    state.close()

    duration = time.monotonic() - started
    log.info(
        "Fertig in %.2fs: created=%d updated=%d deleted=%d skipped=%d errors=%d",
        duration, created, updated, deleted, skipped, errors,
    )
    return 0 if errors == 0 else 1


if __name__ == "__main__":
    raise SystemExit(run())
