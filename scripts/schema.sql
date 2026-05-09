CREATE TABLE IF NOT EXISTS log_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    log_date TEXT,
    log_time TEXT,
    username TEXT,
    status TEXT,
    source_ip TEXT
);

