output "instance_public_ip" {
  description = "Public IP of the fresh EC2 instance"
  value       = aws_instance.k3s_node.public_ip
}
