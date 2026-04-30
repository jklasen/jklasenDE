"""Thin wrapper around the Google Calendar API.

Loads OAuth credentials persisted by auth.py and exposes
insert / patch / delete plus a list helper that filters by our
extendedProperties.private.exchangeUid marker.
"""
from __future__ import annotations

import logging
from pathlib import Path
from typing import Any, Optional

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

log = logging.getLogger(__name__)

SCOPES = ["https://www.googleapis.com/auth/calendar.events"]


def load_credentials(token_path: Path) -> Credentials:
    token_path = Path(token_path).expanduser()
    if not token_path.exists():
        raise FileNotFoundError(
            f"Kein Google-Token unter {token_path}. Bitte zuerst `python auth.py` ausführen."
        )
    creds = Credentials.from_authorized_user_file(str(token_path), SCOPES)
    if creds.expired and creds.refresh_token:
        creds.refresh(Request())
        token_path.write_text(creds.to_json())
    if not creds.valid:
        raise RuntimeError("Google-Token ist nicht gültig. `python auth.py` erneut ausführen.")
    return creds


class GoogleWriter:
    def __init__(self, token_path: Path, calendar_id: str):
        self.calendar_id = calendar_id
        creds = load_credentials(token_path)
        # cache_discovery=False avoids noisy warnings without a writable cache dir
        self.service = build("calendar", "v3", credentials=creds, cache_discovery=False)

    def insert(self, body: dict[str, Any]) -> dict[str, Any]:
        # sendUpdates="none" is critical: even though we never set attendees,
        # this is a defense-in-depth against accidental invitations.
        return self.service.events().insert(
            calendarId=self.calendar_id,
            body=body,
            sendUpdates="none",
        ).execute()

    def patch(self, event_id: str, body: dict[str, Any]) -> dict[str, Any]:
        return self.service.events().patch(
            calendarId=self.calendar_id,
            eventId=event_id,
            body=body,
            sendUpdates="none",
        ).execute()

    def delete(self, event_id: str) -> bool:
        try:
            self.service.events().delete(
                calendarId=self.calendar_id,
                eventId=event_id,
                sendUpdates="none",
            ).execute()
            return True
        except HttpError as e:
            if e.resp.status in (404, 410):
                # already gone – treat as success
                return True
            log.warning("Löschen von %s fehlgeschlagen: %s", event_id, e)
            return False

    def get(self, event_id: str) -> Optional[dict[str, Any]]:
        try:
            return self.service.events().get(
                calendarId=self.calendar_id,
                eventId=event_id,
            ).execute()
        except HttpError as e:
            if e.resp.status in (404, 410):
                return None
            raise

    def find_by_exchange_uid(self, exchange_uid: str) -> Optional[dict[str, Any]]:
        """Re-match orphans (e.g. lost SQLite) via extendedProperty."""
        resp = self.service.events().list(
            calendarId=self.calendar_id,
            privateExtendedProperty=f"exchangeUid={exchange_uid}",
            showDeleted=False,
            maxResults=2,
        ).execute()
        items = resp.get("items", [])
        return items[0] if items else None

    def list_calendars(self) -> list[dict[str, Any]]:
        return self.service.calendarList().list().execute().get("items", [])
