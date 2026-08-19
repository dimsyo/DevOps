variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of Public Subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of Private Subnet CIDRs"
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "List of Database Subnet CIDRs"
}
