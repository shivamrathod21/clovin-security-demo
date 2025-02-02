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
  region = "us-west-2"
}

# Get existing VPC and subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get existing security group
data "aws_security_group" "existing" {
  name = "allow_web_traffic"
}

# Create security group for RDS
resource "aws_security_group" "rds" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.existing.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mysql"
  }
}

# Create DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "clovin-security-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "Clovin Security DB subnet group"
  }
}

# Create RDS instance
resource "aws_db_instance" "mysql" {
  identifier           = "clovin-security-db"
  allocated_storage    = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = "vulnerabilities"
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "clovin-security-db"
  }
}

# Reference the existing EC2 instance
data "aws_instance" "app_server" {
  instance_id = "i-02095903fa9586491"
}

# Output the public IP and DB endpoint
output "public_ip" {
  value       = data.aws_instance.app_server.public_ip
  description = "The public IP of the web server"
}

output "db_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "The endpoint of the MySQL database"
}
