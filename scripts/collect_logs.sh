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
tail -n 100 "$SOURCE_LOG" > "$OUTPUT"

# Check if collected logs have any useful SSH entries
USEFUL=$(grep -cE "Failed|Accepted" "$OUTPUT" 2>/dev/null)
USEFUL=${USEFUL:-0}

if [ "$USEFUL" -eq 0 ]; then
    echo "⚠️  No SSH login events found in real log. Generating test data..."
    cat > "$OUTPUT" << 'EOF'
May 13 16:00:01 localhost sshd[1001]: Failed password for root from 192.168.1.100 port 22 ssh2
May 13 16:00:05 localhost sshd[1002]: Failed password for admin from 192.168.1.100 port 22 ssh2
May 13 16:00:10 localhost sshd[1003]: Failed password for omar from 10.0.0.5 port 22 ssh2
May 13 16:00:15 localhost sshd[1004]: Failed password for test from 10.0.0.5 port 22 ssh2
May 13 16:01:00 localhost sshd[1005]: Accepted password for omar from 192.168.1.1 port 22 ssh2
May 13 16:01:30 localhost sshd[1006]: Accepted publickey for omar from 192.168.1.1 port 22 ssh2
EOF
    echo "✅ Test data generated → $OUTPUT"
else
    echo "✅ Collected $USEFUL SSH log lines → $OUTPUT"
fi
