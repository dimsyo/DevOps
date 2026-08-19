output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of Public Subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of Private Subnet IDs"
}

output "database_subnet_ids" {
  value       = aws_subnet.database[*].id
  description = "List of Database Subnet IDs"
}
