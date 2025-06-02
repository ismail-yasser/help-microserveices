# Microservices Deployment and Management Guide

This guide provides comprehensive instructions for deploying and managing the Kubernetes microservices project using the provided automation scripts.

## 📁 Script Overview

### 🚀 Quick Start Scripts

- **`quick-start.bat`** - Fastest way to get the project running
- **`setup-development.bat`** - Complete development environment setup
- **`deploy-project.bat`** - Main deployment script with multiple options

### 🔧 Deployment Scripts

- **`deploy-k8s-manifests.bat`** - Deploy using Kubernetes manifests
- **`deploy-helm-charts.bat`** - Deploy using Helm charts (production-ready)
- **`deploy-production.bat`** - Production deployment with validation
- **`build-images.bat`** - Build Docker images with versioning support

### 🎛️ Management Scripts

- **`manage-project.bat`** - Interactive management console (14 operations)
- **`check-status.bat`** - Comprehensive status checking
- **`start-services.bat`** / **`stop-services.bat`** - Service lifecycle control
- **`restart-services.bat`** - Rolling restart of all services
- **`scale-services.bat`** - Interactive scaling (1-10 replicas)

### 📊 Monitoring and Diagnostics

- **`view-logs.bat`** - Advanced log viewer with filtering
- **`monitor-resources.bat`** - Resource monitoring (CPU, memory, HPA)
- **`health-checks.bat`** - 9-point health assessment
- **`troubleshoot.bat`** - Comprehensive diagnostics and automated fixes

### 🔄 Maintenance Scripts

- **`update-images.bat`** - Docker image management and updates
- **`backup-config.bat`** - Configuration backup with restore instructions
- **`rollback-deployment.bat`** - Rollback deployments and Helm releases
- **`cleanup-project.bat`** - Complete project cleanup

### 🌐 Utility Scripts

- **`get-service-urls.bat`** - Smart URL discovery (Minikube + cloud)

## 🚀 Getting Started

### Option 1: Interactive Navigation (Recommended)

```batch
# Main script launcher with organized menu
scripts\index.bat
```

### Option 2: Ultra-Quick Start (2 minutes)

```batch
# Fastest deployment - minimal setup
scripts\quick-start\quick-start.bat --quick
```

### Option 3: Development Setup (5-10 minutes)

```batch
# Complete development environment
scripts\quick-start\setup-development.bat
```

### Option 4: Browse by Category

```batch
# Navigate to specific script categories
scripts\deployment\        - Build and deployment
scripts\management\        - Service management  
scripts\monitoring\        - Status and diagnostics
scripts\maintenance\       - Updates and cleanup
```

## 📋 Prerequisites

### Required Tools

- **Docker Desktop** - Container platform
- **kubectl** - Kubernetes CLI
- **Minikube** - Local Kubernetes cluster (or other K8s cluster)

### Optional Tools

- **Helm** - Package manager for Kubernetes (enables advanced deployments)
- **Node.js** - For frontend development

### System Requirements

- **Memory**: 4GB+ available for Minikube
- **CPU**: 2+ cores
- **Storage**: 10GB+ free space

## 🎯 Common Usage Scenarios

### 1. First-Time Setup

```batch
# Complete setup for new developers
scripts\setup-development.bat

# Or for quick testing
scripts\quick-start.bat
```

### 2. Daily Development

```batch
# Check project status
scripts\check-status.bat

# View logs
scripts\view-logs.bat
```

### 3. Production Deployment

```batch
# Production deployment with Helm
scripts\deploy-production.bat

# Or use Helm for production
scripts\deploy-helm-charts.bat production
```

### 4. Project Management

```batch
# Interactive management console
scripts\manage-project.bat

# Direct operations
scripts\start-services.bat
scripts\stop-services.bat
scripts\scale-services.bat
```

### 5. Troubleshooting

```batch
# Automated diagnostics
scripts\troubleshoot.bat

# Health checks
scripts\health-checks.bat
```

## 🔧 Script Features

### Deploy Project (`deploy-project.bat`)

1. **Quick Deploy** - Fast deployment using kubectl

2. **Production Deploy** - Helm-based production deployment

### Management Console (`manage-project.bat`)

1. Check overall status

2. View service logs

### Service Scaling (`scale-services.bat`)

- Scale all services at once
- Choose replica count (1-10)

### Log Viewer (`view-logs.bat`)

- Service selection (user-service, help-service, frontend, all)
- Real-time status updates
- Time range filtering (last 1h, 24h, 7 days, custom)
- Output options (console, file, real-time streaming)
- Error filtering and highlighting

### Health Checks (`health-checks.bat`)

1. Cluster connectivity

2. Deployment status

3. Pod health

4. Service availability

5. Endpoint connectivity

## 🌐 Environment Support

### Local Development (Minikube)

- Automatic Minikube detection
- Local URL generation with `minikube service`
- Development-specific configurations

### Cloud Environments

- AWS EKS, GCP GKE, Azure AKS support
- Production resource configurations
- Cloud-specific networking

### Namespace Management

- Development namespace isolation
- Custom namespace support
- Resource quotas and limits

## 📊 Monitoring

### Resource Monitoring

```batch
# Check specific metrics
scripts\monitor-resources.bat
```

### Log Analysis

```batch
# Real-time log streaming
scripts\view-logs.bat
```

### Health Monitoring

```batch
# Continuous monitoring
scripts\health-checks.bat
```

## 🚀 CI/CD Integration

### Image Building

```batch
# Build and push to registry
scripts\build-images.bat --version v1.2.3
```

### Automated Deployment

```batch
# Kubernetes manifest deployment
scripts\deploy-k8s-manifests.bat

# Helm deployment for production
scripts\deploy-helm-charts.bat production
```

### Rollback Procedures

```batch
# Specific deployment rollback
scripts\rollback-deployment.bat
```

## 🔧 Troubleshooting

### 1. Pods Not Starting

```batch
# Diagnosis
scripts\troubleshoot.bat

# Solutions
scripts\restart-services.bat
```

### 2. Services Not Accessible

```batch
# Check service status
scripts\check-status.bat

# Get service URLs
scripts\get-service-urls.bat
```

### 3. Minikube Issues

```batch
# Restart Minikube
minikube stop && minikube start

# Reset Minikube
minikube delete && minikube start
```

### 4. Resource Issues

```batch
# Scale down services
scripts\scale-services.bat

# Clean up resources
scripts\cleanup-project.bat
```

### Automated Troubleshooting

1. Restart all services

2. Rebuild and redeploy images

3. Reset development environment

4. Clean and redeploy

5. Fix common configuration issues

## 📁 Folder Structure

```text
scripts/
├── README.md                    - Complete documentation
├── index.bat                    - Main navigation script
├── quick-start/                 - Fast setup scripts
│   ├── quick-start.bat
│   ├── setup-development.bat
│   └── README.md
├── deployment/                  - Build and deployment
│   ├── deploy-project.bat
│   ├── deploy-k8s-manifests.bat
│   ├── deploy-helm-charts.bat
│   ├── deploy-production.bat
│   ├── build-images.bat
│   └── README.md
├── management/                  - Service management
│   ├── manage-project.bat
│   ├── start-services.bat
│   ├── stop-services.bat
│   ├── restart-services.bat
│   ├── scale-services.bat
│   └── README.md
├── monitoring/                  - Status and diagnostics
│   ├── check-status.bat
│   ├── view-logs.bat
│   ├── monitor-resources.bat
│   ├── health-checks.bat
│   ├── troubleshoot.bat
│   └── README.md
├── maintenance/                 - Updates and cleanup
│   ├── update-images.bat
│   ├── backup-config.bat
│   ├── rollback-deployment.bat
│   ├── cleanup-project.bat
│   └── README.md
├── validation/                  - Testing and validation
│   └── README.md
└── utilities/                   - Helper scripts
    ├── get-service-urls.bat
    └── README.md
```

## 🔄 Best Practices

### Development Workflow

1. Start with `quick-start.bat` for immediate testing

2. Use `setup-development.bat` for complete environment

3. Use `manage-project.bat` for daily operations

4. Monitor with `health-checks.bat` and `monitor-resources.bat`

### Production Deployment

1. Use `deploy-production.bat` for validated production deployment

2. Implement backup strategy with `backup-config.bat`

3. Implement backup strategy with `backup-config.bat`

4. Set up monitoring with `monitor-resources.bat`

### Maintenance

1. Regular health checks with `health-checks.bat`

2. Keep images updated with `update-images.bat`

3. Image updates with `update-images.bat`

4. Cleanup old resources with `cleanup-project.bat`

## 🆘 Support and Help

### Script Help

```batch
# Get help for any script
script-name.bat --help
```

### Status Checking

```batch
# Quick status overview
scripts\check-status.bat
```

### Comprehensive Diagnostics

```batch
# Full system diagnostics
scripts\troubleshoot.bat
```

### Management Console

```batch
# Interactive management interface
scripts\manage-project.bat
```

## 📈 Advanced Features

### Multi-Environment Support

- Development, staging, production environments
- Environment-specific configurations

### Scaling and Performance

- Horizontal Pod Autoscaling (HPA)
- Resource monitoring and optimization

### Security

- Network policies for production
- Secret management

### Backup and Recovery

- Configuration backup and restore
- Disaster recovery procedures

---

For detailed information about each script category, refer to the README.md files in their respective folders.
