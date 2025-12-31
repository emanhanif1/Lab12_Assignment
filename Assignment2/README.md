# Assignment2 — Terraform Project (Part 1)

## Purpose
This README documents the project structure and basic information for the Terraform setup.  
It shows a clean and modular organization of files and folders for Assignment2.

---

## Project Overview
This project contains Terraform configurations organized in a dedicated directory (`Assignment2`) to prevent committing sensitive files and large state files.  
Modules and scripts are separated for clarity and reusability.

---

## Project Structure

Assignment2/
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── terraform.tfvars
├── . gitignore
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs. tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs. tf
│   └── webserver/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── scripts/
│   ├── nginx-setup.sh
│   └── apache-setup.sh
└── README.md

---

## Modules & Scripts Explanation

- **Modules:**
  - `networking`: Contains VPC, subnets, and routing logic.
  - `security`: Contains security groups and firewall rules.
  - `webserver`: Contains web server setup (Apache/Nginx EC2 configuration).

- **Scripts:**
  - `nginx-setup.sh`: Installs and configures Nginx for load balancing.
  - `apache-setup.sh`: Installs and configures Apache backend servers.

---

## .gitignore Note
Sensitive files and Terraform state files are excluded:

.terraform/
*.tfstate
*.tfstate.backup
terraform.tfvars
*.log
> This ensures the repository stays clean and no sensitive information is committed

-----                 Internet
                     │
            ┌────────┴─────────┐
            │   Nginx Server   │
            │  (Load Balancer) │
            │   - SSL/TLS      │
            │   - Caching      │
            │   - Reverse Proxy│
            └────────┬─────────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
         ▼           ▼           ▼
      ┌─────┐     ┌─────┐     ┌─────┐
      │Web-1│     │Web-2│     │Web-3│
      │     │     │     │     │(BKP)│
      └─────┘     └─────┘     └─────┘
   Primary       Primary      Backup

   Explanation of Components

Internet – Users access the web application via HTTP/HTTPS.
Nginx Server – Acts as a reverse proxy and load balancer, handles SSL/TLS, caching, and distributes traffic to backend servers.

Web-1 & Web-2 (Primary) – Active backend servers serving the web application.

Web-3 (Backup) – Backup server; only serves traffic if primary servers fail.

This diagram and description fulfill the architecture overview requirement of your assignment.
2)Prerequisites

Before deploying the multi-tier web infrastructure, ensure the following requirements are met:

1. Required Tools

You need the following tools installed on your local machine:

Terraform (v1.6+ recommended)

Used to provision AWS resources.

Installation guide: Terraform Downloads

AWS CLI (v2 recommended)

Used to configure AWS credentials and interact with AWS.

Installation guide: AWS CLI Installation

SSH Client

For connecting to EC2 instances.

Linux/macOS: Already available via terminal (ssh).

Windows: Use PowerShell or PuTTY
.

Text Editor

To edit configuration files (VS Code, Vim, Nano, etc.).

2. AWS Credentials Setup

You need an AWS account with proper permissions to create resources.

Create an IAM User

Permissions: AdministratorAccess or custom policy with EC2, VPC, IAM, Security Groups, and S3 access.

Configure AWS CLI

aws configure


Enter the following when prompted:

AWS Access Key ID

AWS Secret Access Key

Default region name (e.g., me-central-1)

Default output format (optional, e.g., json)

Verify Configuration

aws sts get-caller-identity


Should return your AWS account information.

3. SSH Key Setup

SSH keys are used to securely access EC2 instances.

Generate a Key Pair (if not already created):

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "terraform-key"


Public key path: ~/.ssh/id_ed25519.pub

Private key path: ~/.ssh/id_ed25519

Provide the public key to Terraform

In terraform.tfvars:

public_key  = "~/.ssh/id_ed25519.pub"
private_key = "~/.ssh/id_ed25519"


Verify SSH Access

After deployment, connect to an instance:

ssh -i ~/.ssh/id_ed25519 ec2-user@<public-ip>
3)Deployment Instructions
1. Step-by-Step Guide
Step 1: Generate SSH Key Pair (if not already created)

Generate a key pair to access your EC2 instances:

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "terraform-key"


Public key path: ~/.ssh/id_ed25519.pub

Private key path: ~/.ssh/id_ed25519

These keys will be used in Terraform to create EC2 key pairs for SSH access.

Step 2: Configure Terraform Variables

Variables are defined in variables.tf and customized in terraform.tfvars. These control your infrastructure deployment.

2.1 General Variables
variable "vpc_cidr_block" { type = string; description = "CIDR block for VPC" }
variable "subnet_cidr_block" { type = string; description = "CIDR block for Subnet" }
variable "availability_zone" { type = string; description = "AWS Availability Zone" }
variable "env_prefix" { type = string; description = "Environment prefix (e.g., prod, dev)" }
variable "instance_type" { type = string; description = "EC2 instance type" }
variable "public_key" { type = string; description = "Path to public SSH key" }
variable "private_key" { type = string; description = "Path to private SSH key" }
variable "backend_servers" { type = list(object({name=string, script_path=string})); description = "Backend servers list with setup scripts" }

2.2 Example terraform.tfvars
vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
availability_zone = "me-central-1a"
env_prefix        = "prod"
instance_type     = "t3.micro"
public_key        = "~/.ssh/id_ed25519.pub"
private_key       = "~/.ssh/id_ed25519"

backend_servers = [
  { name="web-1", script_path="./scripts/apache-setup.sh" },
  { name="web-2", script_path="./scripts/apache-setup.sh" },
  { name="web-3", script_path="./scripts/apache-setup.sh" }
]


vpc_cidr_block and subnet_cidr_block define the network range.

env_prefix is used for naming resources and tagging.

instance_type decides the EC2 size.

backend_servers list configures each backend EC2 server with its setup script.

Step 3: Initialize Terraform

Navigate to your project directory and initialize Terraform:

terraform init


Downloads required providers (AWS).

Loads all modules (networking, security, webserver).

Step 4: Validate Configuration

Check that your Terraform code is correct:

terraform validate


Detects syntax errors or missing variables.

Ensures modules and variables are properly referenced.

Step 5: Plan Deployment

Preview the infrastructure Terraform will create:

terraform plan


Shows resources that will be created: VPC, Subnet, Internet Gateway, Security Groups, EC2 instances.

Use this step to double-check variable values and resource naming.

Step 6: Apply Deployment

Deploy all infrastructure automatically:

terraform apply -auto-approve


Creates:

VPC, Subnet, Internet Gateway, Route Table

Security Groups (Nginx & Backend)

EC2 Instances (1 Nginx + 3 Backend)

Key Pairs for SSH

Outputs will show public/private IPs and instance IDs.

Step 7: Update Nginx Backend IPs

After deployment, configure Nginx with backend servers’ private IPs:

SSH into the Nginx server:

ssh ec2-user@<nginx-public-ip>


Edit /etc/nginx/nginx.conf and update the upstream block:

upstream backend_servers {
    server 10.0.10.101:80;
    server 10.0.10.102:80;
    server 10.0.10.103:80 backup;
}


Test configuration and restart Nginx:

sudo nginx -t
sudo systemctl restart nginx

Step 8: Testing Procedures

Open https://<nginx-public-ip> in a browser.

Reload multiple times to verify load balancing between primary servers (web-1 & web-2).

Stop web-1 & web-2 to check backup server activation (web-3).

Test caching by observing X-Cache-Status headers.

Health check:

curl -k https://<nginx-public-ip>/health

2. Variable Configuration per Task
Module	Variables	Purpose
Networking	vpc_cidr_block, subnet_cidr_block, availability_zone, env_prefix	Creates VPC, Subnet, IGW, Route Table
Security	vpc_id, env_prefix, my_ip	Creates Nginx & Backend Security Groups
Webserver	env_prefix, instance_name, instance_type, availability_zone, vpc_id, subnet_id, security_group_id, public_key, script_path, instance_suffix, common_tags	Creates EC2 instances with key pair and user data scripts
Locals	backend_servers, my_ip, common_tags	Holds reusable values, dynamic IP detection, and backend server list

Each module references these variables for proper deployment and tagging.

3. Terraform Commands Reference
Command	Description
terraform init	Initialize Terraform and download providers/modules
terraform validate	Validate Terraform code
terraform plan	Preview changes Terraform will make
terraform apply -auto-approve	Deploy resources automatically
terraform output	View outputs (IPs, instance IDs)
terraform destroy	Destroy all deployed resources
terraform output -json > outputs.json	Export outputs in JSON
4)Configuration Guide
1. How to Update Backend IPs

After Terraform deployment, backend servers receive new private IP addresses. These IPs must be added to the Nginx upstream configuration.

Steps:

Get backend private IPs

terraform output


Note the private IPs of:

web-1

web-2

web-3

SSH into the Nginx server

ssh ec2-user@<nginx-public-ip>


Edit Nginx configuration

sudo vim /etc/nginx/nginx.conf


Update the upstream block

upstream backend_servers {
    server <web-1-private-ip>:80;
    server <web-2-private-ip>:80;
    server <web-3-private-ip>:80 backup;
}


Test and restart Nginx

sudo nginx -t
sudo systemctl restart nginx

2. Nginx Configuration Explanation

The Nginx configuration performs reverse proxying, load balancing, caching, and security enforcement.

Key Components:

Upstream Block

Defines backend servers

Uses round-robin load balancing

Includes a backup server for high availability

HTTPS Server (Port 443)

Uses a self-signed SSL certificate

Encrypts all client traffic

Adds security headers

HTTP Server (Port 80)

Redirects all traffic to HTTPS

Caching Configuration

Stores responses in /var/cache/nginx

Improves performance

Reduces backend load

Adds X-Cache-Status header

Security Headers

Prevent clickjacking

Disable MIME sniffing

Enforce HTTPS

3. Testing Procedures
A. Load Balancing Test

Open browser:

https://<nginx-public-ip>


Accept SSL warning

Refresh page multiple times

Verify responses alternate between:

web-1

web-2

Confirm web-3 is not serving traffic (backup only)

B. Cache Testing

Open browser developer tools (F12)

Go to Network tab

First request:

X-Cache-Status: MISS

Reload page:

X-Cache-Status: HIT

CLI Test:

curl -I -k https://<nginx-public-ip>

C. High Availability (Backup Server) Test

Stop Apache on web-1:

sudo systemctl stop httpd


Stop Apache on web-2:

sudo systemctl stop httpd


Reload Nginx page
→ web-3 should serve traffic

Restart Apache services:

sudo systemctl start httpd

D. Health Check Test
curl -k https://<nginx-public-ip>/health


Expected response:

Nginx is healthy
4)Load Balancing Strategy

The system uses Nginx as a reverse proxy and load balancer to distribute incoming client requests across multiple backend Apache web servers. This approach improves performance, availability, and fault tolerance.

Load Balancer Type

Software Load Balancer: Nginx

Deployment: Single Nginx EC2 instance

Protocol: HTTPS (Port 443)

Backend Communication: HTTP (Port 80)

Nginx receives all client traffic and forwards requests to backend servers based on the configured load-balancing rules.

Backend Server Pool

The backend consists of three Apache web servers:

web-1 – Primary backend server

web-2 – Primary backend server

web-3 – Backup backend server

The backup server is used only when the primary servers are unavailable.

Load Balancing Method
Round-Robin (Default Nginx Behavior)

Requests are distributed alternately between web-1 and web-2.

Ensures equal load distribution.

Prevents overloading a single server.

Backup Server Configuration

web-3 is marked as a backup server.

It does not receive traffic during normal operation.

Automatically activates when both primary servers fail.

High Availability Handling

If one primary server fails, traffic continues through the remaining active server.

If both primary servers fail, Nginx automatically routes traffic to the backup server.

No manual intervention is required.

This ensures continuous service availability.

Caching Integration

Nginx caching is enabled at the load balancer level.

Frequently requested responses are served from cache.

Reduces backend server load.

Improves response time and performance.

Security and Performance Enhancements

HTTPS encryption protects client traffic.

HTTP requests are redirected to HTTPS.

Security headers are added at the load balancer.

Backend servers remain private and inaccessible directly.

Conclusion

The load balancing strategy ensures:

Efficient traffic distribution

High availability with backup failover

Improved performance through caching

Enhanced security through centralized access control

This design provides a reliable, scalable, and secure web application infrastruc
5)Security Groups Explanation

Security Groups are used as virtual firewalls to control inbound and outbound traffic for EC2 instances in the infrastructure.
This project uses two separate security groups to enforce the principle of least privilege and improve overall security.

1. Nginx Security Group (Load Balancer)
Purpose

The Nginx security group allows public access to the load balancer while restricting unnecessary ports.

Inbound Rules

HTTPS (Port 443)

Source: 0.0.0.0/0

Allows secure client access to the application.

HTTP (Port 80)

Source: 0.0.0.0/0

Used only to redirect traffic to HTTPS.

SSH (Port 22)

Source: Administrator’s public IP only

Ensures secure remote management.

Outbound Rules

All traffic allowed

Required for forwarding requests to backend servers and receiving responses.

Security Benefit

Public access is limited to web traffic only.

SSH access is restricted to a trusted IP.

Acts as a controlled entry point to the infrastructure.

2. Backend Servers Security Group (Apache Web Servers)
Purpose

This security group protects backend servers by allowing traffic only from the Nginx load balancer.

Inbound Rules

HTTP (Port 80)

Source: Nginx Security Group

Ensures backend servers receive requests only from the load balancer.

SSH (Port 22)

Source: Administrator’s public IP

Allows secure server management.

Outbound Rules

All traffic allowed

Enables system updates and communication with AWS services.


6)Troubleshooting
1. Common Issues and Solutions

Terraform init fails
Cause: Incorrect module path or provider configuration.
Solution: Verify module paths and run:
terraform init -reconfigure

Invalid public_key path
Cause: Terraform cannot access the default .ssh directory.
Solution: Use a relative path inside the project (e.g., scripts/keys/id_ed25519.pub).

EC2 instance not accessible
Cause: Public IP not enabled or subnet not connected to Internet Gateway.
Solution:

Ensure associate_public_ip_address = true

Confirm subnet route table has IGW attached.

Blank Metadata Fields on Webpage
Cause: IMDSv2 requires a session token, which the initial user data script did not fetch.
Solution:

Manually retrieve the IMDSv2 token using curl

Fetch instance metadata (hostname, IP) and update index.html.

Permission Denied on Cache Directory
Cause: ec2-user does not have permission to access /var/cache/nginx/.
Solution:

Inspect using sudo ls -la /var/cache/nginx/

Fix ownership if needed:
sudo chown -R nginx:nginx /var/cache/nginx

2. Log Locations

Nginx (Load Balancer)

Access Log: /var/log/nginx/access.log

Error Log: /var/log/nginx/error.log

Apache (Backend Servers)

Access Log: /var/log/httpd/access_log

Error Log: /var/log/httpd/error_log

Startup / User Data Debugging

/var/log/cloud-init-output.log
(Used to verify whether user_data scripts executed successfully.)

3. Debug Commands

Check Service Status

systemctl status nginx
systemctl status httpd


Verify Cache Status

curl -I https://<nginx-public-ip> --insecure | grep X-Cache-Status


Network Connectivity Test

curl http://<backend-private-ip>