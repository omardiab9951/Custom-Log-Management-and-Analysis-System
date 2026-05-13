#!/usr/bin/env bash
source "$(dirname "$0")/config.sh"
INPUT="$RAW_LOG"
OUTPUT="$SORTED_LOG"

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$OUTPUT")"

# Clear previous output file
> "$OUTPUT"

# Check if input file exists and is not empty
if [ ! -s "$INPUT" ]; then
    echo "⚠️  Warning: $INPUT is empty. Skipping."
    exit 0
fi

# Generate and verify checksum for data integrity
CHECKSUM_FILE="data/raw/auth.log.md5"

echo "🔒 Checking data integrity..."
md5sum "$INPUT" > "$CHECKSUM_FILE"

if md5sum -c "$CHECKSUM_FILE" > /dev/null 2>&1; then
    echo "✅ Integrity check passed: $INPUT"
else
    echo "❌ WARNING: Log file may have been tampered with!"
    exit 1
fi

echo "🔄 Parsing logs..."

while IFS= read -r line || [ -n "$line" ]; do

    # Skip empty lines or lines that don't start with a valid log date
    [[ -z "$line" || ! "$line" =~ [A-Z][a-z]{2}\ [0-9] ]] && continue

    # Extract date, time fields
    DATE=$(echo "$line" | awk '{print $1, $2}')
    TIME=$(echo "$line" | awk '{print $3}')

    # Determine login status
    if echo "$line" | grep -qi "Failed"; then
        STATUS="Failed"
    elif echo "$line" | grep -qi "Accepted"; then
        STATUS="Accepted"
    else
        continue
    fi

    # Extract username and source IP
    USER=$(echo "$line" | awk -F'for '  '{print $2}' | awk '{print $1}')
    IP=$(echo "$line"   | awk -F'from ' '{print $2}' | awk '{print $1}')

    # Skip if either field is missing
    [[ -z "$USER" || -z "$IP" ]] && continue

    # Write parsed entry to CSV output
    echo "$DATE,$TIME,$USER,$STATUS,$IP" >> "$OUTPUT"

done < "$INPUT"

echo "✅ Parsing complete → $OUTPUT"
