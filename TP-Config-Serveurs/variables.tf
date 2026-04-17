variable "aws_region" {
  description = "AWS region where EC2 instances will be created"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "EC2 instance type for the web servers"
  type        = string
  default     = "t2.micro"
}
