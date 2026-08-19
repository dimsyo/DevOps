variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of Public Subnet IDs for ALB deployment"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for ALB"
}
