Network Topology (VPC)
VPC Scope: The entire system is contained within a Virtual Private Cloud (VPC) with the IP range 10.0.0.0/16.

Internet Gateway (IGW): Acts as the bridge between the public internet and the VPC, allowing external users to reach the Nginx proxy.

Subnet Separation: The architecture is divided into a Public Subnet (for the entry point) and a Private Subnet (for the data/web tier) to enhance security.

2. Public Subnet (DMZ)
Range: 10.10.1.0/24.

Nginx Reverse Proxy / Load Balancer:

Public IP: 158.252.95.150.

Private IP: 10.10.1.74.

Instance ID: i-08ea8636fe364f56e.

Key Responsibilities:

Handles SSL Termination (converting HTTPS to HTTP).

Enforces HTTP to HTTPS redirection for security.

Manages Content Caching to improve performance.

Performs Health Checks on backends to ensure traffic only goes to "Healthy" servers.

3. Private Subnet (Backend Tier)
Range: 10.0.10.0/24.

Backend Servers:

web-1 (Primary): Apache server at 10.10.1.71.

web-2 (Primary): Apache server at 10.10.1.12.

web-3 (Backup): Apache server at 10.10.1.140.

Isolation: These servers have no direct internet access and no NAT Gateway, meaning they are completely shielded from the outside world.

4. Security Group Configurations
Nginx Security Group:

SSH (22): Open to Admin IP only.

HTTP (80) & HTTPS (443): Open to Anywhere (0.0.0.0/0) so users can visit the site.

Backend Security Group:

HTTP (80): Traffic is only allowed if it comes from the Nginx Security Group.

SSH (22): Restricted to the Admin IP only.

5. Routing & Traffic Flow
All User Traffic: Must pass through the Nginx instance; there is no way to bypass it to reach the backends.

Public Route Table: Directs all outbound traffic (0.0.0.0/0) to the Internet Gateway.

Private Route Table: Explicitly configured for No direct internet access.
