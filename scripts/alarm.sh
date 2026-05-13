#!/usr/bin/env bash
# scripts/alarm.sh - Cyber Student (Week 2)
# Reads sorted.log (CSV) and triggers ALARM if Failed attempts > 3
source "$(dirname "$0")/config.sh"

SORTED_FILE="$SORTED_LOG"

if [ ! -f "$SORTED_FILE" ]; then
    echo "❌ Error: $SORTED_FILE not found. Run parser.sh first."
    exit 1
fi

# Count lines containing ",Failed," (CSV-safe match)
COUNT=$(grep -c ",Failed," "$SORTED_FILE")

echo "================================="
echo " 🛡️  SCANNING FOR SUSPICIOUS ACTIVITY"
echo "================================="
echo " Found: $COUNT Failed login attempts"
echo ""

if [ "$COUNT" -gt "$ALARM_THRESHOLD" ]; then
    echo "🚨 !!!!!!!!!!!!!!!!!!!!!!!!"
    echo "🚨 !!     ALARM!!!      !!"
    echo "🚨 !! $COUNT Failed Logins !!"
    echo " !! Possible Attack!   !!"
    echo "🚨 !!!!!!!!!!!!!!!!!!!!!!!!"
else
    echo "✅ All clear. Only $COUNT failed attempt(s)."
fi
echo "================================="
