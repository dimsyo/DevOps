# Environment: Production (prod)

module "production_infrastructure" {
  source = "../../"

  aws_region            = var.aws_region
  environment           = "prod"
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  instance_type        = "t3.medium"
  asg_min_size         = 2
  asg_max_size         = 6
  asg_desired_capacity = 2

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = "db.t3.small"
  db_allocated_storage = 50
  multi_az_db          = true
}

output "prod_alb_dns_name" {
  value       = module.production_infrastructure.alb_dns_name
  description = "Production ALB DNS Endpoint"
}

output "prod_rds_endpoint" {
  value       = module.production_infrastructure.rds_endpoint
  description = "Production RDS PostgreSQL Endpoint"
}

variable "aws_region" { default = "ap-southeast-1" }
variable "vpc_cidr" { default = "10.100.0.0/16" }
variable "availability_zones" { default = ["ap-southeast-1a", "ap-southeast-1b"] }
variable "public_subnet_cidrs" { default = ["10.100.1.0/24", "10.100.2.0/24"] }
variable "private_subnet_cidrs" { default = ["10.100.10.0/24", "10.100.11.0/24"] }
variable "database_subnet_cidrs" { default = ["10.100.20.0/24", "10.100.21.0/24"] }
variable "db_name" { default = "prod_db" }
variable "db_username" { default = "prodadmin" }
variable "db_password" { sensitive = true }
