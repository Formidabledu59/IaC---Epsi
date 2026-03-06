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

variable "machines" {
  description = "List of machines to create"
  type = list(object({
    name      = string
    vcpu      = number
    disk_size = number
    region    = string
  }))

  default = [
    {
      name      = "vm-1"
      vcpu      = 2
      disk_size = 20
      region    = "eu-west-1"
    }
  ]

  validation {
    condition = alltrue([for m in var.machines : (
      m.vcpu >= 2 && m.vcpu <= 64 &&
      m.disk_size >= 20 &&
      contains(["eu-west-1", "us-east-1", "ap-southeast-1"], m.region)
    )])
    error_message = "Each machine must have vcpu between 2 and 64, disk_size >= 20, and region one of [eu-west-1, us-east-1, ap-southeast-1]."
  }
}
