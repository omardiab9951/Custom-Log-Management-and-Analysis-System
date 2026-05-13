#!/usr/bin/env bash
#===============================================================================
# SCRIPT NAME: parser.sh
# DESCRIPTION: Parses raw auth.log and extracts login events into CSV format
# AUTHOR: Omar Nasr
# VERSION: 1.1
#===============================================================================

INPUT="data/raw/auth.log"
OUTPUT="data/sorted/sorted.log"

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$OUTPUT")"

# Clear previous output file
> "$OUTPUT"

# Check if input file exists and is not empty
if [ ! -s "$INPUT" ]; then
    echo "⚠️  Warning: $INPUT is empty. Skipping."
    exit 0
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
