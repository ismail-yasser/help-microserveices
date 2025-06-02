# Deployment Scripts

🔧 **Build and deploy your microservices to Kubernetes**

## Scripts in this folder:

### `deploy-project.bat`
- **Purpose**: Main deployment script with multiple options
- **Usage**: `deploy-project.bat`
- **Features**:
  - Interactive menu with 4 deployment modes
  - Quick Deploy (kubectl-based)
  - Production Deploy (Helm-based)
  - Development Deploy (full dev setup)
  - Complete Deploy (all components)

### `deploy-k8s-manifests.bat`
- **Purpose**: Deploy using Kubernetes YAML manifests
- **Usage**: `deploy-k8s-manifests.bat [namespace]`
- **Features**:
  - Direct kubectl deployment
  - ConfigMap and Secret management
  - Service and Deployment creation
  - HPA (Horizontal Pod Autoscaler) setup

### `deploy-helm-charts.bat`
- **Purpose**: Production deployment using Helm charts
- **Usage**: `deploy-helm-charts.bat [environment]`
- **Features**:
  - Environment selection (dev/prod/custom)
  - Helm-based package management
  - Values file customization
  - Release management

### `deploy-production.bat`
- **Purpose**: Validated production deployment
- **Usage**: `deploy-production.bat`
- **Features**:
  - Pre-deployment validation
  - Production security policies
  - Resource quotas and limits
  - Network policies
  - Multi-replica deployment with HPA

### `build-images.bat`
- **Purpose**: Build Docker images with versioning
- **Usage**: `build-images.bat [--version tag] [--push] [--registry url]`
- **Features**:
  - Build all service images
  - Version tagging support
  - Registry push capabilities
  - Image size reporting

## Usage Examples:

```batch
# Interactive deployment menu
scripts\deployment\deploy-project.bat

# Quick Kubernetes deployment
scripts\deployment\deploy-k8s-manifests.bat

# Production Helm deployment
scripts\deployment\deploy-helm-charts.bat production

# Build and tag images
scripts\deployment\build-images.bat --version v1.2.3

# Build and push to registry
scripts\deployment\build-images.bat --push --registry docker.io/myuser
```

## Deployment Environments:

### Development
- Single replicas
- Local storage
- Development configurations
- Relaxed security policies

### Production  
- Multiple replicas (3+ per service)
- Resource quotas and limits
- Network policies
- Health checks and monitoring
- Horizontal Pod Autoscaling

## Prerequisites:
- Docker (for image building)
- kubectl (configured cluster access)
- Helm (for Helm deployments)
- Minikube or cloud cluster

---
💡 **Tip**: Start with `deploy-project.bat` for an interactive experience, then use specific scripts for automation.
