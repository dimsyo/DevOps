#!/usr/bin/env bash
set -e

# Configurable variables
BUCKET_NAME=${1:-"devops-modular-tfstate-bucket-$(date +%s)"}
TABLE_NAME=${2:-"devops-modular-tfstate-locks"}
REGION=${3:-"ap-southeast-1"}

echo "========================================================="
echo "🚀 Initializing Terraform Remote Backend Infrastructure"
echo "Region         : ${REGION}"
echo "S3 Bucket Name : ${BUCKET_NAME}"
echo "DynamoDB Table : ${TABLE_NAME}"
echo "========================================================="

# 1. Create S3 Bucket
echo "📦 Creating S3 Bucket..."
if [ "${REGION}" == "us-east-1" ]; then
    aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${REGION}"
else
    aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${REGION}" \
        --create-bucket-configuration LocationConstraint="${REGION}"
fi

# Enable S3 Bucket Versioning
echo "🔒 Enabling S3 Versioning..."
aws s3api put-bucket-versioning \
    --bucket "${BUCKET_NAME}" \
    --versioning-configuration Status=Enabled

# Enable Default Server-Side Encryption (AES256)
echo "🔑 Enabling Default SSE-S3 Encryption..."
aws s3api put-bucket-encryption \
    --bucket "${BUCKET_NAME}" \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# Block Public Access
echo "🛡️ Blocking Public Access on S3 Bucket..."
aws s3api put-public-access-block \
    --bucket "${BUCKET_NAME}" \
    --public-access-block-configuration '{
        "BlockPublicAcls": true,
        "IgnorePublicAcls": true,
        "BlockPublicPolicy": true,
        "RestrictPublicBuckets": true
    }'

# 2. Create DynamoDB Table for Lock Storage
echo "⚡ Creating DynamoDB Table for State Locking..."
aws dynamodb create-table \
    --table-name "${TABLE_NAME}" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "${REGION}" || echo "DynamoDB table already exists or created."

echo "========================================================="
echo "✅ Remote State Backend setup complete!"
echo "Pass these variables to terraform init:"
echo "terraform init \\"
echo "  -backend-config=\"bucket=${BUCKET_NAME}\" \\"
echo "  -backend-config=\"dynamodb_table=${TABLE_NAME}\" \\"
echo "  -backend-config=\"region=${REGION}\""
echo "========================================================="
