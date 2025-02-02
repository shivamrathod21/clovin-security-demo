# 🛡️ Clovin Security Vulnerability Tracker

[![Build and Deploy](https://github.com/shivamrathod21/clovin-security-demo/actions/workflows/deploy.yml/badge.svg)](https://github.com/shivamrathod21/clovin-security-demo/actions/workflows/deploy.yml)

> *Because tracking vulnerabilities shouldn't be vulnerable!* 🎯

## 🚀 What's This All About?

Ever wondered how to build a **secure**, **scalable**, and **cloud-native** vulnerability tracking system? Well, you're in the right place! This project demonstrates how to create a modern security application using:

- 🐍 Python Flask for the backend
- 🐋 Docker for containerization
- ☁️ AWS for cloud infrastructure
- 🏗️ Terraform for Infrastructure as Code
- 🤖 GitHub Actions for CI/CD

## 🎯 Key Features

- 🔒 **Secure Database**: MySQL RDS with proper security groups
- 🚢 **Container Ready**: Dockerized application for easy deployment
- 🔄 **CI/CD Pipeline**: Automated testing and deployment
- 🏗️ **Infrastructure as Code**: Everything defined in Terraform
- 🌐 **RESTful API**: Clean and well-documented endpoints

## 🏃‍♂️ Quick Start

1. **Clone the repo**
   ```bash
   git clone https://github.com/shivamrathod21/clovin-security-demo.git
   cd clovin-security-demo
   ```

2. **Set up your environment**
   ```bash
   # Create .env file with your settings
   cp .env.example .env
   ```

3. **Run with Docker**
   ```bash
   docker build -t clovin-security .
   docker run -p 5000:5000 clovin-security
   ```

## 🏗️ Architecture

```
                                   ┌─────────────┐
                                   │             │
                               ┌──►│  AWS RDS    │
                               │   │  (MySQL)    │
┌──────────┐    ┌──────────┐  │   │            │
│          │    │          │  │   └─────────────┘
│  GitHub  │───►│   EC2    │──┤
│ Actions  │    │          │  │   ┌─────────────┐
│          │    │          │  │   │             │
└──────────┘    └──────────┘  └──►│  Docker     │
                                   │  Container  │
                                   └─────────────┘
```

## 🔧 Technical Deep Dive

### Infrastructure (Terraform)
- **VPC Configuration**: Using default VPC for simplicity
- **EC2 Instance**: t2.micro running our Docker container
- **RDS Instance**: MySQL 8.0 for data persistence
- **Security Groups**: Properly configured for minimal exposure

### Application (Flask)
- **RESTful API**: CRUD operations for vulnerabilities
- **SQLAlchemy ORM**: Clean database interactions
- **Docker Multi-stage Build**: Optimized container size

### CI/CD (GitHub Actions)
- **Automated Testing**: Unit tests with pytest
- **Infrastructure Deployment**: Terraform automation
- **Container Building**: Docker build and push
- **Zero-downtime Deployment**: Rolling updates

## 📝 API Documentation

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/vulnerabilities` | List all vulnerabilities |
| POST | `/api/vulnerabilities` | Create new vulnerability |
| GET | `/api/vulnerabilities/<id>` | Get specific vulnerability |
| PUT | `/api/vulnerabilities/<id>` | Update vulnerability |
| DELETE | `/api/vulnerabilities/<id>` | Delete vulnerability |

### Example API Calls

```bash
# List all vulnerabilities
curl http://localhost:5000/api/vulnerabilities

# Create a new vulnerability
curl -X POST http://localhost:5000/api/vulnerabilities \
  -H "Content-Type: application/json" \
  -d '{
    "name": "SQL Injection",
    "description": "Potential SQL injection in login form",
    "severity": "High"
  }'

# Get a specific vulnerability
curl http://localhost:5000/api/vulnerabilities/1

# Update a vulnerability
curl -X PUT http://localhost:5000/api/vulnerabilities/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "SQL Injection",
    "description": "Updated description",
    "severity": "Critical"
  }'

# Delete a vulnerability
curl -X DELETE http://localhost:5000/api/vulnerabilities/1
```

## 🔑 SSH Access

To access the EC2 instance via SSH:

1. First, make sure you have an SSH key pair:
   ```bash
   # Generate a new key pair if you don't have one
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

2. When applying Terraform:
   ```bash
   # Set your database password
   export TF_VAR_db_password="your_secure_password"
   
   # Optionally set a custom path to your public key
   export TF_VAR_public_key_path="path/to/your/key.pub"
   
   # Apply Terraform configuration
   terraform init
   terraform apply
   ```

3. SSH into the instance:
   ```bash
   ssh -i ~/.ssh/id_rsa ubuntu@<instance-ip>
   ```

> 💡 **Note**: The instance IP will be shown in the Terraform output after applying.

## 🔧 Troubleshooting Guide

### Common Issues

1. **Database Connection Failed**
   ```
   Error: Unable to connect to database
   ```
   **Solution**: 
   - Check if RDS instance is running
   - Verify DATABASE_URL in .env
   - Ensure security group allows connection

2. **Docker Build Failed**
   ```
   Error: No space left on device
   ```
   **Solution**:
   - Run `docker system prune`
   - Free up disk space
   - Remove unused images

3. **Terraform Apply Failed**
   ```
   Error: Error creating DB Instance
   ```
   **Solution**:
   - Check AWS credentials
   - Verify region settings
   - Ensure sufficient permissions

### Health Check

Run this to verify your setup:
```bash
# Check application status
curl http://localhost:5000/

# Test database connection
python -c "from app import db; db.create_all()"

# Verify Docker container
docker ps | grep clovin-security
```

## 🔐 Security Best Practices

1. **Database Security**
   - RDS encryption at rest
   - Proper security group configuration
   - Regular automated backups

2. **Application Security**
   - Environment variables for secrets
   - Input validation and sanitization
   - Proper error handling

## 🎓 Learning Outcomes

Building this project teaches you:
1. 🏗️ How to set up cloud infrastructure properly
2. 🔒 Implementing security best practices
3. 🚀 Modern deployment workflows
4. 🤖 Automation with GitHub Actions
5. 🐋 Container orchestration

## 🧹 Resource Management

Current AWS Resources:
- EC2 Instance (i-02095903fa9586491)
- RDS Instance (clovin-security-db)
- Associated security groups and networking components

## 🤝 Contributing

Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

## 📜 License

MIT License - feel free to use this for your own projects!

---
Made with ❤️ for the security community
