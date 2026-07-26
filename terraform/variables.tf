variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "instance_type" {
  default = "t3.small"
  type    = string
}

variable "ssh_public_key" {
  description = "The public SSH key for EC2 access"
  type        = string
}
