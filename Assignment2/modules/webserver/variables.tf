variable "env_prefix" {
  type        = string
  description = "Environment prefix (e.g., dev, prod)"
}

variable "instance_name" {
  type        = string
  description = "Base name for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
}

variable "availability_zone" {
  type        = string
  description = "AZ where instance will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where instance will be launched"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instance"
}

variable "security_group_id" {
  type        = string
  description = "Security group to attach to the instance"
}

variable "public_key" {
  type        = string
  description = "Path to the SSH public key"
}

variable "script_path" {
  type        = string
  description = "Path to the setup script (user_data)"
}

variable "instance_suffix" {
  type        = string
  description = "Unique suffix for instance naming"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources"
}
