# Clovin Security - Vulnerability Tracker

A modern security vulnerability tracking system with Docker, GitHub Actions, and Terraform integration. This application allows security teams to track and manage potential security threats and vulnerabilities in real-time.

## Features

- Modern, responsive UI with security-focused design
- Real-time vulnerability tracking
- Severity level management (Low, Medium, High, Critical)
- Automated deployment pipeline
- Cloud infrastructure provisioning

## Components

1. Flask Security API
2. Docker containerization
3. GitHub Actions for automated Docker Hub deployment
4. Terraform configuration for AWS EC2 deployment

## Setup Instructions

### 1. Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

### 2. Docker Setup
```bash
# Build the Docker image
docker build -t clovin-security-demo .

# Run the container
docker run -p 5000:5000 clovin-security-demo
```

### 3. GitHub Actions Setup
1. Add these secrets to your GitHub repository:
   - `DOCKER_HUB_USERNAME`
   - `DOCKER_HUB_ACCESS_TOKEN`

### 4. Terraform Deployment
1. Configure AWS credentials
2. Initialize Terraform:
```bash
terraform init
```
3. Apply the configuration:
```bash
terraform apply -var="docker_username=your-dockerhub-username"
```

## API Endpoints

- GET `/api/vulnerabilities` - List all vulnerabilities
- POST `/api/vulnerabilities` - Create a new vulnerability
- GET `/api/vulnerabilities/<id>` - Get a specific vulnerability
- PUT `/api/vulnerabilities/<id>` - Update a vulnerability
- DELETE `/api/vulnerabilities/<id>` - Delete a vulnerability

## Example Vulnerability JSON
```json
{
    "title": "SQL Injection in Login Form",
    "severity": "High",
    "description": "Potential SQL injection vulnerability detected in the login form's username field"
}
```

## Security Levels

- **Critical**: Immediate attention required, potential for significant damage
- **High**: Serious vulnerability that should be addressed quickly
- **Medium**: Important but not urgent vulnerability
- **Low**: Minor security concern that should be tracked
