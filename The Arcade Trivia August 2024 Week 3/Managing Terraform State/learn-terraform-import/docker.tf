# docker_container.web:
resource "docker_container" "web" {
  name  = "hashicorp-learn"
  image = docker_image.nginx.image_id

  ports {
    external = 8081
    internal = 80
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
}


resource "docker_image" "nginx" {
  name         = "nginx:latest"
}