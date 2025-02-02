terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Store state in S3 to prevent duplicate resources
  backend "s3" {
    bucket = "clovin-terraform-state"
    key    = "seminar-crud-demo/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"  # Change this to your preferred region
}

# Get existing security group
data "aws_security_group" "existing" {
  name = "allow_web_traffic"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0735c191cf914754d"  # Ubuntu 20.04 LTS in us-west-2
  instance_type = "t2.micro"
  count         = 1  # Ensure only one instance

  user_data = <<-EOF
              #!/bin/bash
              # Update and install Docker
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker

              # Wait for Docker to be ready
              sleep 10

              # Pull and run the container
              docker pull ${var.docker_username}/clovin-security-demo:latest
              docker run -d \
                --name flask-app \
                -p 5000:5000 \
                --restart unless-stopped \
                ${var.docker_username}/clovin-security-demo:latest

              # Log the container status
              echo "Container status:" > /var/log/container-status.log
              docker ps >> /var/log/container-status.log
              EOF

  tags = {
    Name = "seminar-crud-demo"
  }

  vpc_security_group_ids = [data.aws_security_group.existing.id]
}

# Output the public IP
output "public_ip" {
  value = aws_instance.app_server[0].public_ip
  description = "The public IP of the web server"
}
