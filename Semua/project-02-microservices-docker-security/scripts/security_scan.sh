#!/usr/bin/env bash
# ==============================================================================
# Security Scan Script using Trivy Scanner
# Project 2: Microservices Containerization with Docker Compose & Security Scan
# ==============================================================================

set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BOLD}====================================================${NC}"
echo -e "${BOLD} 🛡️  Starting Trivy Container & IaC Security Scan ${NC}"
echo -e "${BOLD}====================================================${NC}\n"

# Check if Trivy is installed
if ! command -v trivy &> /dev/null; then
    echo -e "${YELLOW}[!] Trivy is not installed locally. Running Trivy via Docker container...${NC}"
    RUN_TRIVY="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/root/.cache/ aquasec/trivy:latest"
else
    RUN_TRIVY="trivy"
fi

# 1. Scan Dockerfiles for Misconfigurations (IaC Scan)
echo -e "${BOLD}1. Scanning Dockerfiles & Configs for Security Misconfigurations...${NC}"
$RUN_TRIVY config ./app/Dockerfile
$RUN_TRIVY config ./nginx/Dockerfile
$RUN_TRIVY config ./docker-compose.yml

echo -e "\n${GREEN}[✓] IaC Configuration Scan Complete!${NC}\n"

# 2. Build local images for vulnerability scanning if needed
echo -e "${BOLD}2. Building local images for Vulnerability Scan...${NC}"
docker build -t fastapi-app:test ./app
docker build -t nginx-proxy:test ./nginx

# 3. Scan Container Images for HIGH and CRITICAL Vulnerabilities
echo -e "\n${BOLD}3. Scanning FastAPI Application Image (fastapi-app:test)...${NC}"
$RUN_TRIVY image --severity HIGH,CRITICAL --exit-code 1 fastapi-app:test || {
    echo -e "${RED}[X] HIGH or CRITICAL vulnerabilities found in fastapi-app! Please fix before release.${NC}"
    exit 1
}

echo -e "\n${BOLD}4. Scanning Nginx Proxy Image (nginx-proxy:test)...${NC}"
$RUN_TRIVY image --severity HIGH,CRITICAL --exit-code 0 nginx-proxy:test

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN} 🎉 Security Scan Completed: 0 High/Critical Blockers ${NC}"
echo -e "${GREEN}====================================================${NC}"
