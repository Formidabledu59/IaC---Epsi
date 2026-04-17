terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

resource "docker_network" "app" {
  name = "tf-app-net"
}

resource "docker_image" "nginx" {
  name = var.docker_image_name
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  networks_advanced {
    name    = docker_network.app.name
    aliases = ["nginx"]
  }

  ports {
    external = var.external_port
    internal = var.internal_port
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
}

resource "docker_container" "client" {
  for_each = toset(var.client_names)

  name  = "server-${each.value}"
  image = "appropriate/curl:latest"

  networks_advanced {
    name    = docker_network.app.name
    aliases = ["server-${each.value}"]
  }

  command = ["sh", "-c", "curl -sS http://nginx:80 && sleep 30"]

  depends_on = [docker_container.nginx]
}

output "nginx_container_id" {
  description = "identifiant (id) du conteneur nginx"
  value       = docker_container.nginx.id
}

resource "null_resource" "nginx_healthcheck" {
  depends_on = [docker_container.nginx]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      powershell -NoProfile -Command "if (-not ((Invoke-WebRequest -UseBasicParsing -Uri http://localhost:${var.external_port} -TimeoutSec 10).Content -match 'Welcome')) { Write-Error 'La page ne contient pas Welcome'; exit 1 }"
    EOT
  }
}

output "machines" {
  description = "Evaluation de la variable machines (pour valider les contraintes)"
  value       = var.machines
}
