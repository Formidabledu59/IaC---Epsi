output "instance_id" {
  description = "ID of the web EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP of the web EC2 instance"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the web instance"
  value       = "ssh -i deployer-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "db_instance_id" {
  description = "ID of the database EC2 instance"
  value       = aws_instance.database.id
}

output "db_instance_public_ip" {
  description = "Public IP of the database EC2 instance"
  value       = aws_instance.database.public_ip
}

output "bucket_id" {
  description = "ID du bucket S3"
  value       = aws_s3_bucket.demo_bucket.id
}

output "public_file_url" {
  description = "URL publique du fichier S3"
  value       = "https://${aws_s3_bucket.demo_bucket.bucket}.s3.amazonaws.com/${aws_s3_object.demo_object.key}"
}