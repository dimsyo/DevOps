# Note: Before running 'terraform init', ensure the S3 bucket and DynamoDB table exist.
# You can use scripts/init_backend.sh or scripts/init_backend.ps1 to create them.
# Pass custom values during init: terraform init -backend-config="bucket=YOUR_BUCKET" -backend-config="dynamodb_table=YOUR_TABLE"

terraform {
  backend "s3" {
    bucket         = "devops-modular-tfstate-bucket"
    key            = "production-cloud-infrastructure/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "devops-modular-tfstate-locks"
    encrypt        = true
  }
}
