provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible-tp-key"
  public_key = file("${path.module}/ansible_test_key.pub")
}

resource "aws_security_group" "web" {
  name        = "ansible-web-sg"
  description = "Allow SSH and HTTP access for Ansible-managed web servers"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami                       = data.aws_ami.ubuntu.id
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.ansible.key_name
  subnet_id                 = data.aws_subnet_ids.default.ids[0]
  vpc_security_group_ids    = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "dbserver" {
  ami                       = data.aws_ami.ubuntu.id
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.ansible.key_name
  subnet_id                 = data.aws_subnet_ids.default.ids[0]
  vpc_security_group_ids    = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name = "dbserver"
  }
}

locals {
  webserver_host = "webserver ansible_host=${aws_instance.webserver.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./ansible_test_key ansible_python_interpreter=/usr/bin/python3"
  dbserver_host  = "dbserver ansible_host=${aws_instance.dbserver.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./ansible_test_key ansible_python_interpreter=/usr/bin/python3"
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory"
  content = <<-EOF
[webserver]
${local.webserver_host}

[dbserver]
${local.dbserver_host}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=./ansible_test_key
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
EOF
}
