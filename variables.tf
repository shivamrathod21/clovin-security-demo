variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "public_key_path" {
  description = "Path to the public key file for EC2 SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"  # Default path to public key
}
