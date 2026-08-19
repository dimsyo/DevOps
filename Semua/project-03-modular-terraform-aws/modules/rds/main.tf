# DB Subnet Group (Isolated database subnets)
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# DB Parameter Group
resource "aws_db_parameter_group" "postgresql" {
  name   = "${var.environment}-pg15-params"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = {
    Name = "${var.environment}-pg15-params"
  }
}

# AWS RDS PostgreSQL Instance (Multi-AZ High Availability)
resource "aws_db_instance" "main" {
  identifier            = "${var.environment}-postgres-db"
  engine                = "postgres"
  engine_version        = "15.4"
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  parameter_group_name   = aws_db_parameter_group.postgresql.name

  multi_az            = var.multi_az
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name        = "${var.environment}-postgres-db"
    Environment = var.environment
  }
}
