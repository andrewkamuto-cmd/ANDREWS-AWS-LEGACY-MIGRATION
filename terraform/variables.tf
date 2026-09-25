variable "aws_region" {
  description = "AWS region for Andrews AWS Legacy Migration"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "andrews-aws-legacy-migration"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}