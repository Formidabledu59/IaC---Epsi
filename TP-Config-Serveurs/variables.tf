variable "aws_region" {
  description = "AWS region where the application EC2 instance will be created"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "EC2 instance type for the application server"
  type        = string
  default     = "t2.micro"
}
