$ErrorActionPreference = "Stop"

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "🛠️ Terraform Code Formatting & Linting Validation" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# 1. Format Check
Write-Host "🔍 Checking Terraform Formatting (terraform fmt)..." -ForegroundColor Yellow
terraform fmt -check -recursive
Write-Host "✅ Formatting check passed!" -ForegroundColor Green

# 2. Validate Root Module Syntax
Write-Host "🔍 Validating Root Module (terraform validate)..." -ForegroundColor Yellow
terraform init -backend=false
terraform validate
Write-Host "✅ Root module validation passed!" -ForegroundColor Green

# 3. TFLint if available
if (Get-Command tflint -ErrorAction SilentlyContinue) {
    Write-Host "🔍 Running TFLint Linter..." -ForegroundColor Yellow
    tflint --init
    tflint
    Write-Host "✅ TFLint passed!" -ForegroundColor Green
} else {
    Write-Host "ℹ️ TFLint is not installed. Skipping TFLint static analysis." -ForegroundColor Gray
}

Write-Host "=========================================================" -ForegroundColor Green
Write-Host "🎉 All Terraform Validation Checks Completed Successfully!" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
