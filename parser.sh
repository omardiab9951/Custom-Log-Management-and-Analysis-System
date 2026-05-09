#!/usr/bin/env bash

INPUT_FILE="../data/auth.log"
OUTPUT_FILE="../data/parsed_logs.txt"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found!"
    exit 1
fi

# Clear the output file before writing
> "$OUTPUT_FILE"

while read line; do
    # Skip empty/corrupted lines
    [ -z "$line" ] && continue

    # --- Extract Fields ---

    # Date (Month + Day)
    DATE=$(echo "$line" | awk '{print $1, $2}')

    # Time (HH:MM:SS)
    TIME=$(echo "$line" | awk '{print $3}')

    #  Extract Type (service name e.g. sshd, sudo, cron)
    TYPE=$(echo "$line" | awk '{print $5}' | cut -d'[' -f1)

    # Status (only process lines with Failed or Accepted)
    if echo "$line" | grep -q "Failed"; then
        STATUS="Failed"
    elif echo "$line" | grep -q "Accepted"; then
        STATUS="Accepted"
    else
        continue
    fi

    # User
    USER=$(echo "$line" | awk -F'for ' '{print $2}' | awk '{print $1}')

    # Source_IP
    SOURCE_IP=$(echo "$line" | awk -F'from ' '{print $2}' | awk '{print $1}')

    # Skip lines where User or Source_IP could not be extracted
    if [ -z "$USER" ] || [ -z "$SOURCE_IP" ]; then
        continue
    fi

    # Write parsed line to output file
    echo "Date=$DATE Time=$TIME Type=$TYPE User=$USER Status=$STATUS Source_IP=$SOURCE_IP" >> "$OUTPUT_FILE"

done < "$INPUT_FILE"

echo "Parsing completed. Output saved to $OUTPUT_FILE"

#Verify "Failed" filtering

echo ""
echo "--- Failed Login Attempts ---"
FAILED_COUNT=$(grep 'Status=Failed' "$OUTPUT_FILE" | wc -l)

if [ "$FAILED_COUNT" -eq 0 ]; then
    echo "No failed attempts found."
else
    echo "Total Failed attempts: $FAILED_COUNT"
    echo ""
    grep 'Status=Failed' "$OUTPUT_FILE"
fi
