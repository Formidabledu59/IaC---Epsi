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
variable "client_names" {
  description = "List of client names used to create containers"
  type        = list(string)
  default     = ["a", "b", "c"]
}
variable "internal_port" {
  description = "internal port of container"
  type        = number
  default     = 80
}