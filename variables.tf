# Docker Hub username
variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

# Database password
variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

# SSH key path
variable "public_key_path" {
  description = "Path to the public key file for EC2 SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
