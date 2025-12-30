Error 1: SSH Identity File Not Accessible
Message: Warning: Identity file ... not accessible: No such file or directory. Permission denied (publickey).

Cause: The SSH command is looking for a private key (.pem) at a path that does not exist, or the filename is misspelled.

Solution: * Verify the exact path of your key using ls.

Ensure you are using the correct filename (e.g., terraform_key.pem).

Fix: Run chmod 400 <key_name> and provide the full path in your SSH command.

Error 2: Apache Directory Not Found
Message: tee: /var/www/html/index.html: No such file or directory

Cause: You are trying to write the index.html file before the Apache web server (httpd) is installed or the directory structure is created.

Solution: * Confirm Apache is installed: sudo yum install httpd -y.

The directory /var/www/html/ is created automatically during the httpd installation.

Fix: Run sudo systemctl start httpd first, then try the echo command again.

Error 3: Connection Timeout to Private IPs
Message: Connection timeout when trying to access 10.10.x.x from a local machine.

Cause: Private IPs (10.x.x.x) are not routable over the public internet. Your local machine or GitHub Codespace is outside the VPC and cannot "see" these internal addresses.

Solution: * The "Bastion" Method: You must first SSH into the Nginx Proxy (which has a Public IP).

Internal Routing: Once inside the Nginx server, you can then SSH or curl to the Private IPs of the backend servers.

Verification: Ensure the Security Group for the backends allows inbound traffic on Port 80/22 from the Nginx server's Private IP or Security Group ID.
Permission Denied for /etc/nginx/nginx.conf
error 4: You are trying to write to a system configuration file as a standard user (ec2-user). Files in /etc/ are owned by the root user for security reasons.

The Solution: You must use sudo (SuperUser Do) to gain administrative privileges.

To Edit: Use sudo nano /etc/nginx/nginx.conf or sudo vi /etc/nginx/nginx.conf.

To Overwrite/Redirect: If you are using echo or cat to push content into the file, use tee:


cat new_config.conf | sudo tee /etc/nginx/nginx.conf
error5: Syntax Error in add_header
The Problem: The line you provided (add_header Content-Type text/plain;i;ache_status...) appears to be corrupted or incorrectly copied. Nginx directives must follow a very strict format: directive_name value;.

Correct Format for Headers: If you are trying to add the Cache Status and Security Headers, use this clean format inside your server or location block:

# To show if the request was a HIT or MISS
add_header X-Cache-Status $upstream_cache_status always;

# Security Headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
