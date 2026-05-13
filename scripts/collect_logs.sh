#!/usr/bin/env bash
# scripts/collect_logs.sh - Cyber Student (Week 1)
# Copies fresh auth logs to data/raw/auth.log

# RHEL uses /var/log/secure for auth logs, but we'll check both
SOURCE_LOG="/var/log/secure"
[ ! -f "$SOURCE_LOG" ] && SOURCE_LOG="/var/log/auth.log"

OUTPUT="data/raw/auth.log"
mkdir -p data/raw

if [ ! -f "$SOURCE_LOG" ]; then
    echo "❌ Error: No auth log found at $SOURCE_LOG"
    exit 1
fi

echo "📥 Collecting logs from $SOURCE_LOG..."

# Copy only the last 100 lines to keep it fast for testing
tail -n 100 "$SOURCE_LOG" > "$OUTPUT"

LINES=$(wc -l < "$OUTPUT")
echo "✅ Collected $LINES log lines → $OUTPUT"
