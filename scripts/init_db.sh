#!/usr/bin/env bash
# scripts/init_db.sh - Initializes the SQLite database using schema.sql
DB="logs_db.sqlite"
if [ -f "$DB" ]; then
    echo "✅ Database already exists: $DB"
else
    sqlite3 "$DB" < "$(dirname "$0")/schema.sql"
    echo "✅ Database created successfully: $DB"
fi
