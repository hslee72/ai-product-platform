# =============================================================================
# General Variables
# =============================================================================
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ai-product-platform"
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

# =============================================================================
# Network Variables
# =============================================================================
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

# =============================================================================
# ECS Variables
# =============================================================================
variable "backend_cpu" {
  description = "CPU units for backend task"
  type        = number
  default     = 1024
}

variable "backend_memory" {
  description = "Memory (MB) for backend task"
  type        = number
  default     = 2048
}

variable "backend_desired_count" {
  description = "Desired number of backend tasks"
  type        = number
  default     = 2
}

variable "frontend_cpu" {
  description = "CPU units for frontend task"
  type        = number
  default     = 512
}

variable "frontend_memory" {
  description = "Memory (MB) for frontend task"
  type        = number
  default     = 1024
}

variable "frontend_desired_count" {
  description = "Desired number of frontend tasks"
  type        = number
  default     = 2
}

# =============================================================================
# RDS Variables
# =============================================================================
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
  default     = "ai_product_platform"
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_multi_az" {
  description = "Enable RDS Multi-AZ"
  type        = bool
  default     = true
}

# =============================================================================
# Redis Variables
# =============================================================================
variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_cache_nodes" {
  description = "Number of Redis cache nodes"
  type        = number
  default     = 2
}

# =============================================================================
# API Keys (Secrets)
# =============================================================================
variable "anthropic_api_key" {
  description = "Anthropic API key for Claude"
  type        = string
  sensitive   = true
}

variable "openai_api_key" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
}

variable "langfuse_public_key" {
  description = "Langfuse public key for observability"
  type        = string
  sensitive   = true
}

variable "langfuse_secret_key" {
  description = "Langfuse secret key for observability"
  type        = string
  sensitive   = true
}

variable "app_secret_key" {
  description = "Application secret key for JWT"
  type        = string
  sensitive   = true
}

# =============================================================================
# Domain Variables
# =============================================================================
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
  type        = string
  default     = ""
}
