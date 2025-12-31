variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR format (e.g. x.x.x.x/32)"
  type        = string
}
