terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
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

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker pull ${var.docker_username}/clovin-security-demo:latest
              docker run -d -p 5000:5000 ${var.docker_username}/clovin-security-demo:latest
              EOF

  tags = {
    Name = "seminar-crud-demo"
  }

  vpc_security_group_ids = [data.aws_security_group.existing.id]
}
