# AWS Key Pair
resource "aws_key_pair" "instance_key" {
  key_name   = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}-key"
  public_key = file(var.public_key)
}

# EC2 Instance
resource "aws_instance" "server" {
  ami                    = "ami-05524d6658fcf35b6" # Amazon Linux 2023
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name               = aws_key_pair.instance_key.key_name
  availability_zone      = var.availability_zone
  user_data              = file(var.script_path)

  tags = merge(var.common_tags, {
    Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}"
  })
}
