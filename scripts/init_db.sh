#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit 1

DB="logs_db.sqlite"

if sqlite3 "$DB" ".tables" 2>/dev/null | grep -q "log_entries"; then
    echo "✅ Database already initialized: $DB"
else
    sqlite3 "$DB" < "$(dirname "$0")/schema.sql"
    echo "✅ Database created successfully: $DB"
fi

