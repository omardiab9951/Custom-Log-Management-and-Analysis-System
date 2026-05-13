#!/usr/bin/env bash
#===============================================================================
# SCRIPT NAME: config.sh
# DESCRIPTION: Centralized configuration for all scripts
# AUTHOR: Omar Diab
# VERSION: 1.0
#===============================================================================

# Project paths
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="$PROJECT_DIR/data"
RAW_LOG="$DATA_DIR/raw/auth.log"
SORTED_LOG="$DATA_DIR/sorted/sorted.log"
DB_FILE="$PROJECT_DIR/logs_db.sqlite"
REPORTS_DIR="$PROJECT_DIR/reports"

# System paths
SYSTEM_LOG="/var/log/secure"
[ ! -f "$SYSTEM_LOG" ] && SYSTEM_LOG="/var/log/auth.log"

# Thresholds
ALARM_THRESHOLD=3
CRON_INTERVAL="*/10"

# Colors for UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Export all variables
export PROJECT_DIR DATA_DIR RAW_LOG SORTED_LOG DB_FILE REPORTS_DIR
export SYSTEM_LOG ALARM_THRESHOLD CRON_INTERVAL
export RED GREEN YELLOW BLUE NC
