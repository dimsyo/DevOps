#!/usr/bin/env bash
# ==============================================================================
# Automated Infrastructure Setup Script
# Project 01: Automated Linux Web Infrastructure & Git Workflow
# ==============================================================================
# Fail-safe strict mode:
# -e : Exit immediately if a command exits with a non-zero status.
# -u : Treat unset variables as an error.
# -o pipefail : Return status of the last command that failed in the pipeline.
set -euo pipefail

# Color Codes for Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}" >&2
}

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    log_error "Please run this script as root or with sudo."
    exit 1
fi

log_info "Starting Automated Infrastructure Setup..."

# 1. Update Package Repositories & Install Core Packages
log_info "Updating apt package repository..."
apt-get update -y

log_info "Installing Required Dependencies (Nginx, Python3, Certbot, UFW, Curl)..."
apt-get install -y nginx python3 python3-pip certbot python3-certbot-nginx ufw curl logrotate

# 2. Configure System User & Group for Backend App
APP_USER="www-data"
APP_DIR="/opt/my-python-app"
LOG_DIR="/var/log/my-app"

log_info "Setting up application directory & permissions..."
mkdir -p "${APP_DIR}"
mkdir -p "${LOG_DIR}"

chown -R ${APP_USER}:${APP_USER} "${APP_DIR}"
chown -R ${APP_USER}:${APP_USER} "${LOG_DIR}"
chmod 755 "${APP_DIR}"
chmod 750 "${LOG_DIR}"

# 3. Configure Firewall (UFW)
log_info "Configuring Firewall (UFW) rules..."
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 'Nginx Full'

# Enable UFW non-interactively if not already enabled
if ! ufw status | grep -q "Status: active"; then
    echo "y" | ufw enable
fi

# 4. Verify Services Status
log_info "Verifying Nginx Installation..."
systemctl enable nginx
systemctl restart nginx

log_success "Infrastructure Provisioning Completed Successfully!"
log_info "Application Directory: ${APP_DIR}"
log_info "Log Directory: ${LOG_DIR}"
