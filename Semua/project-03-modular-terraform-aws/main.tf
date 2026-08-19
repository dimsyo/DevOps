# Root Module: Production Cloud Infrastructure on AWS

# 1. Network Module (VPC, Subnets, Gateways, Route Tables)
module "vpc" {
  source = "./modules/vpc"

  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
}

# 2. Security Groups Module (ALB, EC2, RDS Firewalls)
module "security_group" {
  source = "./modules/security_group"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

# 3. Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group_id  = module.security_group.alb_security_group_id
}

# 4. Compute & Auto Scaling Group Module
module "asg" {
  source = "./modules/asg"

  environment          = var.environment
  private_subnet_ids   = module.vpc.private_subnet_ids
  security_group_id    = module.security_group.ec2_security_group_id
  target_group_arn     = module.alb.target_group_arn
  instance_type        = var.instance_type
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
  user_data_script_path = "${path.module}/scripts/user_data.sh"
}

# 5. Relational Database Service (RDS) Module
module "rds" {
  source = "./modules/rds"

  environment          = var.environment
  database_subnet_ids  = module.vpc.database_subnet_ids
  security_group_id    = module.security_group.rds_security_group_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  multi_az             = var.multi_az_db
}
