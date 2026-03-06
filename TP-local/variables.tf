variable "docker_image_name" {
  description = "name of the Docker image"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "name of the Docker container"
  type        = string
  default     = "nginx-terraform"
}

variable "external_port" {
  description = "external port exposed container"
  type        = number
  default     = 8081
}
variable "client_count" {
  description = "Number of curl client containers to deploy"
  type        = number
  default     = 3
}
variable "internal_port" {
  description = "internal port of container"
  type        = number
  default     = 80
}