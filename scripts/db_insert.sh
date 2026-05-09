#!/usr/bin/env bash
# scripts/db_insert.sh - Loads parsed CSV into SQLite database
DB="logs_db.sqlite"
CSV="data/sorted/sorted.log"

if [ ! -f "$CSV" ]; then
    echo "❌ Error: $CSV not found. Run parser.sh first."
    exit 1
fi

echo "📥 Inserting data into database..."

# Clear old data to avoid duplicates during testing
sqlite3 "$DB" "DELETE FROM log_entries;"

# Read CSV line by line and insert
while IFS=',' read -r DATE TIME USER STATUS IP; do
    [[ -z "$DATE" || "$DATE" == *"log_date"* ]] && continue
    sqlite3 "$DB" "INSERT INTO log_entries (log_date, log_time, username, status, source_ip) VALUES ('$DATE', '$TIME', '$USER', '$STATUS', '$IP');"
done < "$CSV"

echo "✅ Data insertion complete. Total rows: $(sqlite3 "$DB" "SELECT COUNT(*) FROM log_entries;")"
