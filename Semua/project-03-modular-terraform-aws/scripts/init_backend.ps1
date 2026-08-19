[CmdletBinding()]
param (
    [string]$BucketName = "devops-modular-tfstate-bucket-$((Get-Date).Ticks)",
    [string]$TableName = "devops-modular-tfstate-locks",
    [string]$Region = "ap-southeast-1"
)

$ErrorActionPreference = "Stop"

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "🚀 Initializing Terraform Remote Backend Infrastructure" -ForegroundColor Cyan
Write-Host "Region         : $Region"
Write-Host "S3 Bucket Name : $BucketName"
Write-Host "DynamoDB Table : $TableName"
Write-Host "=========================================================" -ForegroundColor Cyan

# 1. Create S3 Bucket
Write-Host "📦 Creating S3 Bucket..." -ForegroundColor Yellow
if ($Region -eq "us-east-1") {
    aws s3api create-bucket --bucket $BucketName --region $Region
} else {
    aws s3api create-bucket --bucket $BucketName --region $Region --create-bucket-configuration LocationConstraint=$Region
}

# Enable S3 Versioning
Write-Host "🔒 Enabling S3 Versioning..." -ForegroundColor Yellow
aws s3api put-bucket-versioning --bucket $BucketName --versioning-configuration Status=Enabled

# Enable Default Encryption
Write-Host "🔑 Enabling Default SSE-S3 Encryption..." -ForegroundColor Yellow
$EncryptionConfig = '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
aws s3api put-bucket-encryption --bucket $BucketName --server-side-encryption-configuration $EncryptionConfig

# Block Public Access
Write-Host "🛡️ Blocking Public Access..." -ForegroundColor Yellow
$PublicBlockConfig = '{"BlockPublicAcls":true,"IgnorePublicAcls":true,"BlockPublicPolicy":true,"RestrictPublicBuckets":true}'
aws s3api put-public-access-block --bucket $BucketName --public-access-block-configuration $PublicBlockConfig

# 2. Create DynamoDB Table
Write-Host "⚡ Creating DynamoDB Table for State Locking..." -ForegroundColor Yellow
try {
    aws dynamodb create-table `
        --table-name $TableName `
        --attribute-definitions AttributeName=LockID,AttributeType=S `
        --key-schema AttributeName=LockID,KeyType=HASH `
        --billing-mode PAY_PER_REQUEST `
        --region $Region
} catch {
    Write-Host "DynamoDB Table may already exist. Continuing..." -ForegroundColor Gray
}

Write-Host "=========================================================" -ForegroundColor Green
Write-Host "✅ Remote State Backend setup complete!" -ForegroundColor Green
Write-Host "Run terraform init with:" -ForegroundColor White
Write-Host "terraform init -backend-config=`"bucket=$BucketName`" -backend-config=`"dynamodb_table=$TableName`" -backend-config=`"region=$Region`"" -ForegroundColor Yellow
Write-Host "=========================================================" -ForegroundColor Green
