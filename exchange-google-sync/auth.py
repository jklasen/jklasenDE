#!/usr/bin/env python3
"""Initial OAuth setup for Google Calendar.

Reads ~/.config/exchange-google-sync/client_secret.json (Desktop-App credentials),
opens a browser flow, and persists the refresh-token under
~/.config/exchange-google-sync/token.json. Lists available calendars at the end
so the user can pick the target calendar id for config.yaml.
"""
from __future__ import annotations

import sys
from pathlib import Path

from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

from lib.google_writer import SCOPES

CONFIG_DIR = Path("~/.config/exchange-google-sync").expanduser()
CLIENT_SECRET = CONFIG_DIR / "client_secret.json"
TOKEN_FILE = CONFIG_DIR / "token.json"


def main() -> int:
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)

    if not CLIENT_SECRET.exists():
        print(
            f"FEHLER: {CLIENT_SECRET} nicht gefunden.\n"
            "Bitte in der Google Cloud Console eine OAuth-Client-ID vom Typ\n"
            "'Desktop App' erzeugen und das JSON unter obigem Pfad ablegen.",
            file=sys.stderr,
        )
        return 1

    flow = InstalledAppFlow.from_client_secrets_file(str(CLIENT_SECRET), SCOPES)
    creds = flow.run_local_server(port=0, prompt="consent", access_type="offline")

    TOKEN_FILE.write_text(creds.to_json())
    TOKEN_FILE.chmod(0o600)
    print(f"OK: Token gespeichert in {TOKEN_FILE}\n")

    service = build("calendar", "v3", credentials=creds, cache_discovery=False)
    cals = service.calendarList().list().execute().get("items", [])

    print("Verfügbare Kalender (ID → Name → Zugriff):")
    for c in cals:
        print(f"  {c['id']}\t{c.get('summary', '')}\t{c.get('accessRole', '')}")
    print(
        "\nTrage die ID des Ziel-Kalenders unter google.target_calendar_id in "
        "config.yaml ein."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
