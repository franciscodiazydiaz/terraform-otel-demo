variable "environment" {
  type        = string
  description = "The name of the environment (dev, stage or prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "The environment name must be: dev, stage or prod"
  }
}

variable "project" {
  type        = string
  description = "The name of the project used as reference for tags, and resource names"
  default     = "otel-demo"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
