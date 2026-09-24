variable "aws_region" {
  description = "AWS region for Swaggertys migration infrastructure"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "swaggertys-migration"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}