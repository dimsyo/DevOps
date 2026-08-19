variable "environment" {
  type        = string
  description = "Environment name"
}

variable "database_subnet_ids" {
  type        = list(string)
  description = "List of Database Subnet IDs"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for RDS"
}

variable "db_name" {
  type        = string
  description = "Name of initial database"
  default     = "production_db"
}

variable "db_username" {
  type        = string
  description = "Master database username"
  default     = "dbadmin"
}

variable "db_password" {
  type        = string
  description = "Master database password"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "RDS Instance Class"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage size in GB"
  default     = 20
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
  default     = true
}
