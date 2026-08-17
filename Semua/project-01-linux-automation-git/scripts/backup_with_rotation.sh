#!/usr/bin/env bash
# ==============================================================================
# Automated Backup Script with Log Rotation & Webhook Notification
# ==============================================================================
set -euo pipefail

# Parameters / Arguments with defaults
SRC_DIR="${1:-/var/log/my-app}"
BACKUP_DIR="${2:-/var/backups/my-app}"
WEBHOOK_URL="${3:-}"
RETENTION_DAYS="${4:-7}"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"
HOSTNAME=$(hostname)

# Function to send status notification via Webhook (Discord / Telegram / Generic JSON)
send_notification() {
    local status="$1"
    local message="$2"

    if [ -z "${WEBHOOK_URL}" ]; then
        echo "[LOG] Webhook URL not provided. Skipping notification."
        return 0
    fi

    echo "[LOG] Sending ${status} notification to Webhook..."
    
    # Construct JSON Payload (Compatible with Discord Webhook format)
    local color=65280 # Green for Success
    if [ "${status}" != "SUCCESS" ]; then
        color=16711680 # Red for Failure
    fi

    local payload=$(cat <<EOF
{
  "embeds": [
    {
      "title": "Automated Backup Status: ${status}",
      "description": "${message}",
      "color": ${color},
      "fields": [
        { "name": "Host", "value": "${HOSTNAME}", "inline": true },
        { "name": "Source Directory", "value": "${SRC_DIR}", "inline": true },
        { "name": "Backup File", "value": "${BACKUP_FILE}", "inline": false }
      ],
      "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    }
  ]
}
EOF
)

    curl -s -H "Content-Type: application/json" -X POST -d "${payload}" "${WEBHOOK_URL}" || true
}

trap 'send_notification "FAILED" "Backup process encountered an error on line $LINENO!"' ERR

echo "=== Starting Automated Backup ==="
echo "Source: ${SRC_DIR}"
echo "Destination: ${BACKUP_DIR}"

# 1. Ensure Backup Directory Exists
mkdir -p "${BACKUP_DIR}"

# 2. Trigger Log Rotation prior to backup if logrotate config exists
if [ -f "/etc/logrotate.d/my-python-app" ]; then
    echo "[LOG] Triggering forced log rotation..."
    logrotate -f /etc/logrotate.d/my-python-app || true
fi

# 3. Create Compressed Archive tar.gz
if [ -d "${SRC_DIR}" ]; then
    tar -czf "${BACKUP_FILE}" -C "$(dirname "${SRC_DIR}")" "$(basename "${SRC_DIR}")"
    FILE_SIZE=$(du -sh "${BACKUP_FILE}" | cut -f1)
    echo "[SUCCESS] Created backup archive: ${BACKUP_FILE} (${FILE_SIZE})"
else
    echo "[ERROR] Source directory ${SRC_DIR} does not exist!"
    exit 1
fi

# 4. Clean up old backups based on retention policy
echo "[LOG] Cleaning up backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}" -type f -name "backup_*.tar.gz" -mtime +"${RETENTION_DAYS}" -exec rm -f {} \;

# 5. Send Success Webhook Notification
send_notification "SUCCESS" "Backup created successfully! Archive size: ${FILE_SIZE}."
echo "=== Backup Completed Successfully ==="
