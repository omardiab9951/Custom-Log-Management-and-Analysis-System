#!/usr/bin/env bash
# scripts/db_insert.sh - Loads parsed CSV into SQLite database
source "$(dirname "$0")/config.sh"
DB="$DB_FILE"
CSV="$SORTED_LOG"

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
    # Sanitize fields to prevent SQL injection
    DATE=$(echo "$DATE" | sed "s/'/''/g")
    TIME=$(echo "$TIME" | sed "s/'/''/g")
    USER=$(echo "$USER" | sed "s/'/''/g")
    STATUS=$(echo "$STATUS" | sed "s/'/''/g")
    IP=$(echo "$IP" | sed "s/'/''/g")
    sqlite3 "$DB" "INSERT INTO log_entries (log_date, log_time, username, status, source_ip) VALUES ('$DATE', '$TIME', '$USER', '$STATUS', '$IP');"
done < "$CSV"

echo "✅ Data insertion complete. Total rows: $(sqlite3 "$DB" "SELECT COUNT(*) FROM log_entries;")"
