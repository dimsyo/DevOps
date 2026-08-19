#!/usr/bin/env bash
set -e

echo "========================================================="
echo "🛠️ Terraform Code Formatting & Linting Validation"
echo "========================================================="

# 1. Format Check
echo "🔍 Checking Terraform Formatting (terraform fmt)..."
terraform fmt -check -recursive
echo "✅ Formatting check passed!"

# 2. Validate Root Module Syntax
echo "🔍 Validating Root Module (terraform validate)..."
terraform init -backend=false
terraform validate
echo "✅ Root module validation passed!"

# 3. Check optional TFLint if installed
if command -v tflint &> /dev/null; then
    echo "🔍 Running TFLint Linter..."
    tflint --init || true
    tflint
    echo "✅ TFLint passed!"
else
    echo "ℹ️ TFLint is not installed. Skipping TFLint static analysis."
fi

echo "========================================================="
echo "🎉 All Terraform Validation Checks Completed Successfully!"
echo "========================================================="
