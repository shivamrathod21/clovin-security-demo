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

resource "aws_instance" "app_server" {
  ami           = "ami-0735c191cf914754d"  # Ubuntu 20.04 LTS in us-west-2
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker pull ${var.docker_username}/seminar-crud-demo:latest
              docker run -d -p 5000:5000 ${var.docker_username}/seminar-crud-demo:latest
              EOF

  tags = {
    Name = "seminar-crud-demo"
  }

  vpc_security_group_ids = [aws_security_group.allow_web.id]
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}
