#!/bin/bash

# Load environment variables from .env file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
else
    echo "Error: .env file not found at $SCRIPT_DIR/.env" >&2
    exit 1
fi

# Validate required configuration variables
if [ -z "$SOURCE_DIR" ] || [ -z "$REMOTE_NAME" ] || [ -z "$REMOTE_DIR" ] || [ -z "$LOG_FILE" ]; then
    echo "Error: Missing required variables in .env file (SOURCE_DIR, REMOTE_NAME, REMOTE_DIR, LOG_FILE must be set)." >&2
    exit 1
fi

if [ "$ENCRYPT" = "true" ] && [ -z "$CRYPT_REMOTE_NAME" ]; then
    echo "Error: ENCRYPT is set to true but CRYPT_REMOTE_NAME is missing in .env file." >&2
    exit 1
fi

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

# Determine target remote based on encryption setting
if [ "$ENCRYPT" = "true" ]; then
    REMOTE_TARGET="$CRYPT_REMOTE_NAME:"
else
    REMOTE_TARGET="$REMOTE_NAME:$REMOTE_DIR"
fi

# Run synchronization
if "$RCLONE_BIN" sync "$SOURCE_DIR" "$REMOTE_TARGET" --log-file "$LOG_FILE" --log-level INFO; then
    echo "Backup completed successfully at $(date)" >> "$LOG_FILE"
else
    echo "Backup FAILED at $(date)" >> "$LOG_FILE"
    exit 1
fi
