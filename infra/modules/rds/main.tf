# RDS Module
variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "private_subnet_ids" {}
variable "app_security_group_id" {}
variable "instance_class" { default = "db.t3.medium" }
variable "allocated_storage" { default = 20 }
variable "db_name" {}
variable "username" {}
variable "password" { sensitive = true }
variable "multi_az" { default = true }

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}"
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_encrypted = true

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = var.multi_az
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final"

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  performance_insights_enabled = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds"
    Environment = var.environment
  }
}

output "db_instance_endpoint" {
  value     = aws_db_instance.main.endpoint
  sensitive = true
}

output "db_instance_id" {
  value = aws_db_instance.main.id
}

output "security_group_id" {
  value = aws_security_group.rds.id
}
