#!/bin/bash
# =====================================
# main.sh - Cyber Student
# Runs the full pipeline:
#   1. Collect  (check log exists)
#   2. Parse    (parser.sh)
#   3. Alarm    (alarm.sh)
#   4. IP Alert (alert_ip.sh)
# Cron runs this every 10 minutes.
# =====================================

# Go to the scripts directory no matter where cron calls this from
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LOG_OUT="../data/pipeline_run.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "===============================" | tee -a "$LOG_OUT"
echo " Pipeline started: $TIMESTAMP"  | tee -a "$LOG_OUT"
echo "===============================" | tee -a "$LOG_OUT"

# --- Step 1: Collect ---
echo ""                                | tee -a "$LOG_OUT"
echo "[1/5] Collecting logs..."        | tee -a "$LOG_OUT"
bash collect_logs.sh 2>&1             | tee -a "$LOG_OUT"

# --- Step 2: Parse ---
echo ""                                | tee -a "$LOG_OUT"
echo "[2/5] Parsing logs..."           | tee -a "$LOG_OUT"
bash parser.sh 2>&1                   | tee -a "$LOG_OUT"

# --- Step 3: Alarm check ---
echo ""                                | tee -a "$LOG_OUT"
echo "[3/4] Running alarm check..."    | tee -a "$LOG_OUT"
bash alarm.sh 2>&1                    | tee -a "$LOG_OUT"

# --- Step 4: IP alert ---
echo ""                                | tee -a "$LOG_OUT"
echo "[4/4] Running IP alert check..." | tee -a "$LOG_OUT"
bash alert_ip.sh 2>&1                 | tee -a "$LOG_OUT"

echo ""                                         | tee -a "$LOG_OUT"
echo "Pipeline finished: $(date '+%H:%M:%S')"   | tee -a "$LOG_OUT"
echo "==============================="           | tee -a "$LOG_OUT"

# =============================================
# HOW TO SET UP THE CRON JOB (run once manually)
# =============================================
# Open crontab editor:      crontab -e
# Add this line at the bottom (every 10 minutes):
#   */10 * * * * bash /root/Safe-Vision-Log-System/scripts/main.sh
#
# Save and exit. Verify it's saved:
#   crontab -l
# =============================================
#
#
