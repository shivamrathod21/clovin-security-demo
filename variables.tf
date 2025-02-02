variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}
