output "app_public_ip" {
  description = "Public IP address of the application EC2 instance"
  value       = aws_instance.appserver.public_ip
}

output "inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = local_file.ansible_inventory.filename
}
