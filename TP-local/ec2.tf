# Generate SSH key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.key.public_key_openssh
}

# Store private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/deployer-key.pem"
  file_permission = "0600"
}

# Create EC2 instance with Nginx
resource "aws_instance" "web" {
  ami             = "ami-12345678"
  instance_type   = var.ec2_instance_type
  security_groups = [aws_security_group.web.name]
  key_name        = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y nginx1
              systemctl start nginx
              systemctl enable nginx

              echo "<h1>Hello from Terraform and LocalStack!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = var.ec2_instance_name
    Role = "web-server"
  }
}

# Create EC2 instance for database
resource "aws_instance" "database" {
  ami             = "ami-12345678"
  instance_type   = var.ec2_instance_type
  security_groups = [aws_security_group.web.name]
  key_name        = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mariadb-server
              systemctl start mariadb
              systemctl enable mariadb
              EOF

  tags = {
    Name = "database-server"
    Role = "db-server"
  }
}