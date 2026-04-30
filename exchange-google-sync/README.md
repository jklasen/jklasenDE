# exchange-google-sync

One-Way-Sync von einem Exchange-Konto (eingebunden in macOS Calendar.app)
in einen dedizierten Google-Kalender. Läuft als launchd-Job auf einem
Mac Mini alle 15 Minuten.

## Architektur

- **Read-Side**: EventKit (PyObjC) liest Events direkt aus Calendar.app.
  Authentifizierung gegen Exchange übernimmt macOS — kein eigener
  EWS-/Graph-Code, kein gespeichertes Passwort im Skript.
- **Write-Side**: Google Calendar API v3 mit OAuth-User-Flow (eigenes
  GCP-Projekt, Desktop-Client-Credentials). Refresh-Token persistent in
  `~/.config/exchange-google-sync/token.json`.
- **State**: SQLite unter `~/.config/exchange-google-sync/state.db`,
  Mapping `exchange_uid → google_event_id` plus Content-Hash für Idempotenz.
- **Scheduler**: launchd, alle 900 Sekunden.

Wiederholungs-Events werden in v1 als expandierte Einzelvorkommen
übertragen (kein RRULE-Mirror) — einfacher und robuster.

## Wichtig: keine Attendees in Google

CID-Teilnehmer werden **nie** als Google-Attendees gesetzt, sondern als
Text in die Beschreibung geschrieben. Sonst würde dein privates
Google-Konto die Teilnehmer als "neue Einladung" behandeln und ggf. Mails
an CID-Kunden und -Kollegen versenden. Zusätzlich wird `sendUpdates="none"`
auf jedem API-Call gesetzt — Belt-and-suspenders gegen Invite-Spam.

## Setup

1. **Google Cloud Console**
   - Neues Projekt anlegen.
   - Calendar API aktivieren.
   - OAuth-Consent-Screen: External, App-Name frei wählbar, eigene Adresse
     als Test-User eintragen.
   - OAuth-Client-ID Typ "Desktop App" erzeugen, JSON herunterladen.
   - Datei nach `~/.config/exchange-google-sync/client_secret.json` ablegen:
     ```
     mkdir -p ~/.config/exchange-google-sync
     mv ~/Downloads/client_secret_*.json ~/.config/exchange-google-sync/client_secret.json
     chmod 600 ~/.config/exchange-google-sync/client_secret.json
     ```

2. **Ziel-Kalender** in Google Calendar anlegen (z.B. "Jens CID") und
   ggf. für die Frau freigeben.

3. **Repo-Setup**
   ```
   cd ~/exchange-google-sync
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   cp config.yaml.example config.yaml
   ```

4. **Auth-Setup**
   ```
   python auth.py
   ```
   Browser-Flow durchlaufen. Am Ende werden alle verfügbaren Kalender mit
   ID gelistet. Die ID des Ziel-Kalenders unter
   `google.target_calendar_id` in `config.yaml` eintragen.

5. **Erster Lauf manuell**
   ```
   python sync.py
   ```
   Beim ersten Lauf erscheint der macOS-Prompt für Calendar-Zugriff.
   Falls der Prompt nicht erscheint oder verweigert wurde, manuell unter
   *Systemeinstellungen → Datenschutz & Sicherheit → Kalender* den Python-
   Binary aus `./venv/bin/python` zulassen.

6. **launchd installieren**
   - In `plist/com.jklasen.exchange-google-sync.plist` alle Vorkommen von
     `/Users/REPLACE_ME` durch deinen tatsächlichen Home-Pfad ersetzen.
   - Installieren:
     ```
     cp plist/com.jklasen.exchange-google-sync.plist ~/Library/LaunchAgents/
     launchctl load ~/Library/LaunchAgents/com.jklasen.exchange-google-sync.plist
     ```
   - Sofort einmal triggern:
     ```
     launchctl start com.jklasen.exchange-google-sync
     ```

7. **Verifizieren**
   ```
   tail -f ~/Library/Logs/exchange-google-sync.log
   ```

## Sync-Logik

Pro Lauf:

1. EventKit-Authorization prüfen.
2. Events im Fenster `[heute - window_past_days, heute + window_future_days]`
   aus dem konfigurierten macOS-Account einlesen.
3. Pro Event:
   - SHA-256-Hash über Titel, Start, Ende, Ort, Notizen, Teilnehmernamen,
     Status, Verfügbarkeit bilden.
   - Mapping in SQLite prüfen (oder per `extendedProperty.exchangeUid`
     wiederfinden, falls SQLite verloren ging).
   - **Neu** → `events.insert`.
   - **Existiert + Hash unverändert** → skip.
   - **Existiert + Hash geändert** → `events.patch`.
   - **Status = cancelled** → `events.delete`.
4. GC: Mappings, deren `exchange_uid` nicht mehr im aktuellen
   EventKit-Fenster auftaucht, aber deren ursprünglicher Start im Fenster
   liegt → in Google löschen + Mapping entfernen.
5. Statistik in Log: created/updated/deleted/skipped/errors, Laufzeit.

## Konfiguration

Siehe `config.yaml.example`. Wichtige Schalter:

- `sync.mode`:
  - `"full"`: Titel, Notizen, Ort, Teilnehmernamen werden übertragen.
  - `"busy"`: nur Zeitblock mit `busy_title` (Default `CID-Termin`).
- `sync.attendees_as_description`: wenn `true`, werden Teilnehmernamen
  in das Description-Feld geschrieben (statt als echte Attendees).
- `exchange.calendars`: optional, leer = alle Kalender im Account.

## Out of Scope (v1)

- Bidirektionaler Sync (Google → Exchange)
- Native RRULE-Übertragung
- Anhänge
- Conference-Daten / Teams-Links als Google-Meet umschreiben

## Troubleshooting

- **`Calendar-Zugriff verweigert`**: Systemeinstellungen → Datenschutz &
  Sicherheit → Kalender. Eintrag für `python` aus `./venv/bin/python`
  zulassen. Ggf. Eintrag entfernen und beim nächsten Lauf neu erteilen.
- **`Kein Kalender im Account 'CID' gefunden`**: Account-Name in
  `config.yaml` mit Internet-Accounts-Konfiguration abgleichen. Im Log
  werden die verfügbaren Sources gelistet.
- **`Kein Google-Token unter ...`**: `python auth.py` ausführen.
- **launchd-Job läuft nicht**: `launchctl list | grep jklasen`,
  `tail ~/Library/Logs/exchange-google-sync.err.log`.
