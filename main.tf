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

# Security group for EC2
resource "aws_security_group" "ec2" {
  name        = "clovin-security-ec2"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask app access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "clovin-security-ec2"
  }
}

# Create key pair for EC2 instance
resource "aws_key_pair" "deployer" {
  key_name   = "clovin-security-key"
  public_key = file(var.public_key_path)
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

# Create EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-0735c191cf914754d"  # Ubuntu 20.04 LTS in us-west-2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id             = data.aws_subnets.default.ids[0]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3-pip
              git clone https://github.com/shivamrathod21/clovin-security-demo.git
              cd clovin-security-demo
              pip3 install -r requirements.txt
              export DATABASE_URL="${aws_db_instance.mysql.endpoint}"
              python3 app.py
              EOF

  tags = {
    Name = "clovin-security-app"
  }
}

# Output the public IP and DB endpoint
output "public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "The public IP of the web server"
}

output "db_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "The endpoint of the MySQL database"
}
