variable "environment" {
  type        = string
  description = "Environment name"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of Private Subnet IDs for EC2 placement"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for EC2 instances"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of ALB Target Group"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in ASG"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in ASG"
  default     = 4
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in ASG"
  default     = 2
}

variable "user_data_script_path" {
  type        = string
  description = "Path to user data shell script file"
}
