# VPC CIDR block
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.vpc_cidr_block))
    error_message = "vpc_cidr_block must be a valid CIDR format (e.g., 10.0.0.0/16)"
  }
}

# Subnet CIDR block
variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.10.0/24"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.subnet_cidr_block))
    error_message = "subnet_cidr_block must be a valid CIDR format (e.g., 10.0.10.0/24)"
  }
}

# Availability zone
variable "availability_zone" {
  description = "Availability zone for resource deployment"
  type        = string
  default     = "me-central-1a"
}

# Environment prefix
variable "env_prefix" {
  description = "Environment prefix (e.g., prod, dev)"
  type        = string
  default     = "prod"
}

# EC2 instance type
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

# SSH public key path
variable "public_key" {
   description = "Path to the SSH public key for EC2 instances"
  type        = string
  default = "scripts/keys/id_ed25519.pub"
}


# SSH private key path
variable "private_key" {
  description = "Path to the SSH private key"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

# Backend servers list of objects (3 servers)
variable "backend_servers" {
  description = "List of backend servers with their name and setup script path"
  type = list(object({
    name        = string
    script_path = string
  }))
  default = [
    {
      name        = "web-1"
      script_path = "scripts/apache-setup.sh"
    },
    {
      name        = "web-2"
      script_path = "scripts/apache-setup.sh"
    },
    {
      name        = "web-3"
      script_path = "scripts/apache-setup.sh"
    }
  ]
}
