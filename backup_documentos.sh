#!/bin/bash

# Configuration
SOURCE_DIR="/home/anomalia/Documentos"
REMOTE_NAME="gdrive"
REMOTE_DIR="Backup_Documentos"
LOG_FILE="/home/anomalia/driveSync/backup.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

echo "========================================" >> "$LOG_FILE"
echo "Starting backup at $(date)" >> "$LOG_FILE"

# Check if rclone is installed
RCLONE_BIN="/usr/bin/rclone"

if [ ! -x "$RCLONE_BIN" ]; then
    echo "Error: rclone not found at $RCLONE_BIN" >> "$LOG_FILE"
    exit 1
fi

# Run synchronization
if "$RCLONE_BIN" sync "$SOURCE_DIR" "$REMOTE_NAME:$REMOTE_DIR" --log-file "$LOG_FILE" --log-level INFO; then
    echo "Backup completed successfully at $(date)" >> "$LOG_FILE"
else
    echo "Backup FAILED at $(date)" >> "$LOG_FILE"
    exit 1
fi
