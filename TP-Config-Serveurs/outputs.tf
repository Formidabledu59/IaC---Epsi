output "public_ips" {
  description = "Public IP addresses of the deployed EC2 instances"
  value       = aws_instance.web.*.public_ip
}

output "inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = local_file.ansible_inventory.filename
}
