output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the created AWS VPC"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of Public Subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of Private Subnet IDs"
}

output "database_subnet_ids" {
  value       = module.vpc.database_subnet_ids
  description = "List of Database Subnet IDs"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Public DNS name of Application Load Balancer"
}

output "alb_arn" {
  value       = module.alb.alb_arn
  description = "ARN of Application Load Balancer"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "Name of the Auto Scaling Group"
}

output "rds_endpoint" {
  value       = module.rds.rds_endpoint
  description = "Connection endpoint for the RDS PostgreSQL database"
}

output "rds_address" {
  value       = module.rds.rds_address
  description = "Address host of the RDS PostgreSQL database"
}

output "rds_port" {
  value       = module.rds.rds_port
  description = "Port of the RDS PostgreSQL database"
}
