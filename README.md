# 🛡️ Clovin Security Vulnerability Tracker

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
