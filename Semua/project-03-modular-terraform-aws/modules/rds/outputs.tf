output "rds_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "Connection endpoint of the RDS PostgreSQL database"
}

output "rds_address" {
  value       = aws_db_instance.main.address
  description = "Hostname address of the RDS PostgreSQL database"
}

output "rds_port" {
  value       = aws_db_instance.main.port
  description = "Port number of the RDS PostgreSQL database"
}

output "rds_db_name" {
  value       = aws_db_instance.main.db_name
  description = "Database name of the RDS PostgreSQL instance"
}
