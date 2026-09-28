CREATE TABLE IF NOT EXISTS subscribers (
  email TEXT PRIMARY KEY NOT NULL,
  interest TEXT NOT NULL,
  consented_at TEXT NOT NULL,
  source TEXT NOT NULL DEFAULT 'join'
);

CREATE TABLE IF NOT EXISTS inquiries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  topic TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TEXT NOT NULL,
  source TEXT NOT NULL DEFAULT 'contact'
);

CREATE INDEX IF NOT EXISTS idx_inquiries_created_at ON inquiries(created_at DESC);
