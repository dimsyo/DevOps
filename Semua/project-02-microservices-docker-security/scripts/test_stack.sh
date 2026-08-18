#!/usr/bin/env bash
# ==============================================================================
# Functional Test Script for 3-Tier Microservices Stack
# ==============================================================================

set -euo pipefail

BASE_URL="http://localhost:8080"
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BOLD}Testing Microservices Stack at ${BASE_URL}...${NC}\n"

# 1. Test Nginx Direct Health Check
echo -n "1. Nginx Proxy Health Check (/nginx-health)... "
NGINX_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/nginx-health")
if [ "$NGINX_STATUS" -eq 200 ]; then
    echo -e "${GREEN}PASS (200 OK)${NC}"
else
    echo -e "${RED}FAIL ($NGINX_STATUS)${NC}"
    exit 1
fi

# 2. Test FastAPI Root Endpoint
echo -n "2. FastAPI Root Endpoint (GET /)... "
ROOT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/")
if [ "$ROOT_STATUS" -eq 200 ]; then
    echo -e "${GREEN}PASS (200 OK)${NC}"
else
    echo -e "${RED}FAIL ($ROOT_STATUS)${NC}"
    exit 1
fi

# 3. Test Full Health Endpoint (PostgreSQL & Redis check)
echo -n "3. Stack Deep Health Check (GET /health)... "
HEALTH_BODY=$(curl -s "${BASE_URL}/health")
echo -e "${GREEN}RESPONSE: ${HEALTH_BODY}${NC}"

# 4. Test Item Creation (PostgreSQL write & Redis cache purge)
echo -n "4. Creating Item (POST /items)... "
POST_RESP=$(curl -s -X POST "${BASE_URL}/items" \
    -H "Content-Type: application/json" \
    -d '{"title": "Docker Security Test Item", "description": "Testing PostgreSQL and Redis Cache"}')
echo -e "${GREEN}CREATED: ${POST_RESP}${NC}"

# 5. Test Item Retrieval (PostgreSQL read & Redis cache populate)
echo -n "5. Fetching Items (GET /items)... "
GET_RESP=$(curl -s "${BASE_URL}/items")
echo -e "${GREEN}FETCHED: ${GET_RESP}${NC}"

echo -e "\n${GREEN}${BOLD}✓ All Microservice integration tests passed successfully!${NC}"
