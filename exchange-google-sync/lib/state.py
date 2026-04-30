import sqlite3
from pathlib import Path
from typing import Iterable


SCHEMA = """
CREATE TABLE IF NOT EXISTS event_map (
    exchange_uid   TEXT PRIMARY KEY,
    google_event_id TEXT NOT NULL,
    content_hash   TEXT NOT NULL,
    last_start     TEXT,
    updated_at     TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_event_map_google_id ON event_map(google_event_id);
"""


class State:
    def __init__(self, db_path: Path):
        db_path = Path(db_path).expanduser()
        db_path.parent.mkdir(parents=True, exist_ok=True)
        self.conn = sqlite3.connect(str(db_path))
        self.conn.row_factory = sqlite3.Row
        self.conn.executescript(SCHEMA)
        self.conn.commit()

    def get(self, exchange_uid: str):
        row = self.conn.execute(
            "SELECT exchange_uid, google_event_id, content_hash, last_start "
            "FROM event_map WHERE exchange_uid = ?",
            (exchange_uid,),
        ).fetchone()
        return dict(row) if row else None

    def upsert(self, exchange_uid: str, google_event_id: str, content_hash: str, last_start: str):
        self.conn.execute(
            "INSERT INTO event_map (exchange_uid, google_event_id, content_hash, last_start) "
            "VALUES (?, ?, ?, ?) "
            "ON CONFLICT(exchange_uid) DO UPDATE SET "
            "  google_event_id = excluded.google_event_id, "
            "  content_hash    = excluded.content_hash, "
            "  last_start      = excluded.last_start, "
            "  updated_at      = datetime('now')",
            (exchange_uid, google_event_id, content_hash, last_start),
        )
        self.conn.commit()

    def delete(self, exchange_uid: str):
        self.conn.execute("DELETE FROM event_map WHERE exchange_uid = ?", (exchange_uid,))
        self.conn.commit()

    def all_within_window(self, window_start_iso: str, window_end_iso: str) -> list[dict]:
        rows = self.conn.execute(
            "SELECT exchange_uid, google_event_id, content_hash, last_start "
            "FROM event_map "
            "WHERE last_start >= ? AND last_start <= ?",
            (window_start_iso, window_end_iso),
        ).fetchall()
        return [dict(r) for r in rows]

    def stale_in_window(self, seen_uids: Iterable[str], window_start_iso: str, window_end_iso: str) -> list[dict]:
        seen = set(seen_uids)
        return [m for m in self.all_within_window(window_start_iso, window_end_iso) if m["exchange_uid"] not in seen]

    def close(self):
        self.conn.close()
