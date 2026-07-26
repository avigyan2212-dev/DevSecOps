terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "voicelingo-deployer-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "k3s_sg" {
  name        = "voicelingo-k3s-sg"
  description = "Allow inbound SSH and Kubernetes traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
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

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "k3s_node" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.k3s_sg.name]

  # Automatically installs k3s fresh on every provision
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              curl -sfL https://get.k3s.io | sh -
              chmod 644 /etc/rancher/k3s/k3s.yaml
              EOF

  tags = {
    Name = "VoiceLingo-k3s-EC2"
  }
}
