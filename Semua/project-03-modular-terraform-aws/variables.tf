# Global & AWS Region Variables
variable "aws_region" {
  type        = string
  description = "AWS Region where resources will be deployed"
  default     = "ap-southeast-1"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# Network / VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones for Multi-AZ deployment"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for Public Subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for Compute Private Subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for Isolated Database Subnets"
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

# Compute / ASG Variables
variable "instance_type" {
  type        = string
  description = "EC2 instance type for Auto Scaling Group"
  default     = "t3.micro"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of EC2 instances in Auto Scaling Group"
  default     = 2
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of EC2 instances in Auto Scaling Group"
  default     = 4
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances in Auto Scaling Group"
  default     = 2
}

# Database / RDS Variables
variable "db_name" {
  type        = string
  description = "Initial PostgreSQL Database name"
  default     = "production_db"
}

variable "db_username" {
  type        = string
  description = "Master username for RDS PostgreSQL instance"
  default     = "dbadmin"
}

variable "db_password" {
  type        = string
  description = "Master password for RDS PostgreSQL instance"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "RDS DB instance class"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage in GB for RDS instance"
  default     = 20
}

variable "multi_az_db" {
  type        = bool
  description = "Enable Multi-AZ deployment for RDS PostgreSQL"
  default     = true
}
