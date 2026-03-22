terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

variable "container_config" {
  default = [
    { name = "web1", port = 8083 },
    { name = "web2", port = 8084 },
    { name = "web3", port = 8085 }
  ]
}

resource "docker_container" "dynamic" {
  for_each = {
    for c in var.container_config : c.name => c
  }

  name  = each.value.name
  image = "nginx:latest"

  ports {
    internal = 80
    external = each.value.port
  }
}

output "urls" {
  value = [
    for c in var.container_config :
    "http://localhost:${c.port}"
  ]
}
