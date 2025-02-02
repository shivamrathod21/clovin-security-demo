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

# Get existing security group
data "aws_security_group" "existing" {
  name = "allow_web_traffic"
}

# Create security group for RDS
resource "aws_security_group" "rds" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"

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

  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = {
    Name = "clovin-security-db"
  }
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

# Output the public IP and DB endpoint
output "public_ip" {
  value = aws_instance.app_server.public_ip
  description = "The public IP of the web server"
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
  description = "The endpoint of the MySQL database"
}
