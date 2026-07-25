provider "aws" {
  region = "us-east-1" # Change this if your AWS defaults to another region
}

# 1. Automatically generate an SSH key
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "k3s_key" {
  key_name   = "voicelingo-k3s-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "voicelingo-k3s-key.pem"
}

# 2. Grab the Default VPC
data "aws_vpc" "default" {
  default = true
}

# 3. Create Security Rules
resource "aws_security_group" "k3s_sg" {
  name        = "voicelingo_k3s_sg"
  description = "Allow SSH, HTTP, and K8s API"
  vpc_id      = data.aws_vpc.default.id

  # SSH for you
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Web Traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Kubernetes API (for GitHub Actions to deploy)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # NodePort range for testing apps before routing
  ingress {
    from_port   = 30000
    to_port     = 32767
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

# 4. Find the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 5. Build the EC2 Instance & Install k3s
resource "aws_instance" "k3s_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.k3s_key.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  # This script runs once when the server starts
  user_data = <<-EOF
              #!/bin/bash
              # Update packages
              apt-get update -y
              # Install k3s (Lightweight Kubernetes)
              curl -sfL https://get.k3s.io | sh -
              
              # Wait for it to initialize
              sleep 15
              
              # Copy the kubeconfig file so we can access it externally
              cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/kubeconfig
              
              # Swap the local IP with the public IP so remote connections work
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              sed -i "s/127.0.0.1/$PUBLIC_IP/g" /home/ubuntu/kubeconfig
              
              # Give the ubuntu user ownership
              chown ubuntu:ubuntu /home/ubuntu/kubeconfig
              EOF

  tags = {
    Name = "VoiceLingo-Live-Server"
  }
}

# 6. Output the IP addresses
output "public_ip" {
  value = aws_instance.k3s_server.public_ip
}
