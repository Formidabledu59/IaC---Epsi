terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
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
  name  = "curl-client"
  image = "appropriate/curl:latest"

  networks_advanced {
    name    = docker_network.app.name
    aliases = ["curl-client"]
  }

  command = ["sh", "-c", "curl -sS http://nginx:80 && sleep 3600"]

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
