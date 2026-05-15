terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Provider configuration for Docker on Windows
provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

# 1. Build the Docker image from your local Dockerfile
resource "docker_image" "app_image" {
  name = "devops-flagship-shop:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}

# 2. Deploy the container using the built image
resource "docker_container" "shop_container" {
  image = docker_image.app_image.image_id
  name  = "devops_production_environment"

  ports {
    internal = 5000
    external = 8080
  }

  # Ensure the container stays running
  restart = "always"
}

# 3. Output the access URL for your demo
output "application_access_url" {
  value       = "http://localhost:8080"
  description = "Access your deployed Flask shop here"
}
