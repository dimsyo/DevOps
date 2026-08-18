# ==============================================================================
# Security Scan Script using Trivy Scanner (PowerShell)
# Project 2: Microservices Containerization with Docker Compose & Security Scan
# ==============================================================================

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host " 🛡️  Starting Trivy Container & IaC Security Scan " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# Check if trivy command exists
$trivyInstalled = Get-Command trivy -ErrorAction SilentlyContinue

if ($trivyInstalled) {
    Write-Host "`n[1] Scanning Dockerfiles & docker-compose.yml for misconfigurations..." -ForegroundColor Yellow
    trivy config ./app/Dockerfile
    trivy config ./nginx/Dockerfile
    trivy config ./docker-compose.yml

    Write-Host "`n[2] Building images for scanning..." -ForegroundColor Yellow
    docker build -t fastapi-app:test ./app
    docker build -t nginx-proxy:test ./nginx

    Write-Host "`n[3] Scanning FastAPI Container Image..." -ForegroundColor Yellow
    trivy image --severity HIGH,CRITICAL --exit-code 0 fastapi-app:test

    Write-Host "`n[4] Scanning Nginx Container Image..." -ForegroundColor Yellow
    trivy image --severity HIGH,CRITICAL --exit-code 0 nginx-proxy:test

    Write-Host "`n====================================================" -ForegroundColor Green
    Write-Host " 🎉 Trivy Security Scan Completed Successfully! " -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green
} else {
    Write-Host "`n[!] Trivy CLI is not directly installed on host." -ForegroundColor Yellow
    Write-Host "[!] Running Trivy via official Docker Container..." -ForegroundColor Yellow
    
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest config ./app/Dockerfile
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest config ./nginx/Dockerfile
    
    Write-Host "`n====================================================" -ForegroundColor Green
    Write-Host " 🎉 Security Scan Completed via Docker Trivy Container! " -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green
}
