output "web_public_ip" {
  description = "Public IP address of the webserver EC2 instance"
  value       = aws_instance.webserver.public_ip
}

output "db_public_ip" {
  description = "Public IP address of the dbserver EC2 instance"
  value       = aws_instance.dbserver.public_ip
}

output "inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = local_file.ansible_inventory.filename
}
