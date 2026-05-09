#!/usr/bin/env bash
# scripts/parser.sh - DS Student A (Week 2)
# Converts raw auth.log into clean, structured CSV for the database
INPUT="data/raw/auth.log"
OUTPUT="data/sorted/sorted.log"


# Safety check
if [ ! -f "$INPUT" ]; then
    echo "❌ Error: $INPUT not found. Run collect_logs.sh first."
    exit 1
fi

# Clear previous output
> "$OUTPUT"

echo "🔄 Parsing logs... (processing line by line)"

while IFS= read -r line; do
    # 🔹 Data Cleaning Rule: Skip empty or malformed lines
    [[ -z "$line" || ! "$line" =~ [A-Z][a-z]{2}\ [0-9] ]] && continue

    # Extract Date & Time
    DATE=$(echo "$line" | awk '{print $1, $2}')
    TIME=$(echo "$line" | awk '{print $3}')

    # Determine Status
    if echo "$line" | grep -qi "Failed"; then
        STATUS="Failed"
    elif echo "$line" | grep -qi "Accepted"; then
        STATUS="Accepted"
    else
        continue # Skip non-auth lines
    fi

    # Extract User & IP
    USER=$(echo "$line" | awk -F'for ' '{print $2}' | awk '{print $1}')
    IP=$(echo "$line" | awk -F'from ' '{print $2}' | awk '{print $1}')

    # Skip if extraction failed
    [[ -z "$USER" || -z "$IP" ]] && continue

    # Output CSV format matching DB schema
    echo "$DATE,$TIME,$USER,$STATUS,$IP" >> "$OUTPUT"
done < "$INPUT"

echo "✅ Parsing complete. Output saved to: $OUTPUT"
