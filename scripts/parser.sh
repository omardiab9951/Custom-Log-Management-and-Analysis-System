#!/usr/bin/env bash
# scripts/parser.sh - DS Student A (Enhanced)
INPUT="data/raw/auth.log"
OUTPUT="data/sorted/sorted.log"

mkdir -p "$(dirname "$OUTPUT")"
> "$OUTPUT"

if [ ! -s "$INPUT" ]; then
    echo "️  Warning: $INPUT is empty. Skipping."
    exit 0
fi

echo "🔄 Parsing logs..."
while IFS= read -r line || [ -n "$line" ]; do
    [[ -z "$line" || ! "$line" =~ [A-Z][a-z]{2}\ [0-9] ]] && continue
    DATE=$(echo "$line" | awk '{print $1, $2}')
    TIME=$(echo "$line" | awk '{print $3}')
    if echo "$line" | grep -qi "Failed"; then STATUS="Failed"
    elif echo "$line" | grep -qi "Accepted"; then STATUS="Accepted"
    else continue; fi
    USER=$(echo "$line" | awk -F'for ' '{print $2}' | awk '{print $1}')
    IP=$(echo "$line" | awk -F'from ' '{print $2}' | awk '{print $1}')
    [[ -z "$USER" || -z "$IP" ]] && continue
    echo "$DATE,$TIME,$USER,$STATUS,$IP" >> "$OUTPUT"
done < "$INPUT"
echo "✅ Parsing complete → $OUTPUT"
