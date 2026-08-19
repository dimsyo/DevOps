# Security Group for Application Load Balancer (Public Facing)
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Controls inbound traffic to ALB from public internet"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP traffic from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTPS traffic from internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

# Security Group for EC2 Auto Scaling Instances (Private Compute Tier)
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-ec2-sg"
  description = "Controls traffic to EC2 instances in private subnets"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP traffic ONLY from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic (via NAT GW)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-sg"
  }
}

# Security Group for RDS PostgreSQL Database (Isolated Data Tier)
resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds-sg"
  description = "Controls traffic to RDS database from application instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL access ONLY from EC2 application tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    description = "Allow outbound response traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-rds-sg"
  }
}
