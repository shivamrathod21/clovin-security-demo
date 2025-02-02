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

# Import the existing working instance
resource "aws_instance" "app_server" {
  # This is your working instance
  instance_id = "i-02095903fa9586491"
  ami           = "ami-0735c191cf914754d"
  instance_type = "t2.micro"

  tags = {
    Name = "seminar-crud-demo"
  }

  vpc_security_group_ids = [data.aws_security_group.existing.id]

  # Prevent recreation of the instance
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      ami,
      user_data,
      instance_type
    ]
  }
}

# Output the public IP
output "public_ip" {
  value = aws_instance.app_server.public_ip
  description = "The public IP of the web server"
}
