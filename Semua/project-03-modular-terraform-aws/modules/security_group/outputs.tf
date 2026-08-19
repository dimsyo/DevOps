output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "Security Group ID for Application Load Balancer"
}

output "ec2_security_group_id" {
  value       = aws_security_group.ec2.id
  description = "Security Group ID for EC2 instances"
}

output "rds_security_group_id" {
  value       = aws_security_group.rds.id
  description = "Security Group ID for RDS PostgreSQL Database"
}
