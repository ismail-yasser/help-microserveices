# 🔍 Task Validation Scripts - Quick Reference

## Overview
This directory contains validation scripts for all 17 Kubernetes microservices project tasks. Each script checks the completion status of its respective task.

## Scripts List

### Individual Tasks (1-9)
| Script                            | Task               | Description                                                |
| --------------------------------- | ------------------ | ---------------------------------------------------------- |
| `01-check-docker-images.bat`      | Docker Images      | Validates Docker images on DockerHub and local Dockerfiles |
| `02-check-deployments.bat`        | K8s Deployments    | Checks deployment files and running pods with 2+ replicas  |
| `03-check-services.bat`           | K8s Services       | Validates service files and ClusterIP/NodePort exposure    |
| `04-check-configmaps-secrets.bat` | ConfigMaps/Secrets | Checks configuration and secret management                 |
| `05-check-api-documentation.bat`  | API Documentation  | Validates API docs with curl examples                      |
| `06-check-load-balancing.bat`     | Load Balancing     | Tests traffic distribution across pod replicas             |
| `07-check-github-repo.bat`        | GitHub Repository  | Validates Git setup and commit history                     |
| `08-check-health-probes.bat`      | Health Probes      | Checks liveness and readiness probe configuration          |
| `09-check-hpa.bat`                | Auto Scaling       | Validates Horizontal Pod Autoscaler setup                  |

### System Tasks (10-17)
| Script                              | Task                 | Description                                     |
| ----------------------------------- | -------------------- | ----------------------------------------------- |
| `10-check-frontend-deployment.bat`  | Frontend Deployment  | Validates React app deployment with 2+ replicas |
| `11-check-frontend-exposure.bat`    | Frontend Exposure    | Checks NodePort/Ingress for external access     |
| `12-check-integration-testing.bat`  | Integration Testing  | Tests end-to-end system communication           |
| `13-check-architecture-diagram.bat` | Architecture Diagram | Validates system documentation and diagrams     |
| `14-check-k8s-organization.bat`     | K8s Organization     | Checks organized manifest structure             |
| `15-check-ingress-controller.bat`   | Ingress Controller   | Validates path-based routing configuration      |
| `16-check-github-actions.bat`       | GitHub Actions       | Checks CI/CD workflow automation                |
| `17-check-helm-chart.bat`           | Helm Chart           | Validates Helm chart structure and deployment   |

## Usage

### Run Individual Task Validation
```cmd
cd scripts\task-validation
01-check-docker-images.bat
```

### Run All Tasks with Menu
```cmd
cd scripts
validate-all-tasks.bat
```

### Quick Single Task Check
```cmd
scripts\task-validation\[task-number]-check-*.bat
```

## Script Features

### ✅ What Each Script Checks
- **File Existence**: Required configuration files
- **Deployment Status**: Running pods and services
- **Configuration**: Proper setup and values
- **Functionality**: Working endpoints and communication
- **Best Practices**: Recommended implementations

### 🔍 Output Format
- ✅ **GREEN**: Task completed successfully
- ❌ **RED**: Task has issues or missing components
- ⚠️ **YELLOW**: Task partially complete or warnings

### 📊 Validation Coverage
- Configuration files in `/k8s` directory
- Running Kubernetes resources
- Docker images on DockerHub
- Service communication and health
- Documentation completeness
- CI/CD pipeline setup

## Prerequisites

### Required Tools
- `kubectl` - Kubernetes command line tool
- `docker` - For image validation
- `git` - For repository checks
- `helm` - For Helm chart validation (optional)

### Required Setup
- Kubernetes cluster running (minikube/kind)
- Deployed services and applications
- Configured kubectl context

## Troubleshooting

### Common Issues
1. **kubectl not found**: Ensure Kubernetes tools are installed
2. **Cluster not accessible**: Start minikube or check cluster status
3. **Services not running**: Deploy required services first
4. **Permission errors**: Run as administrator if needed

### Quick Fixes
```cmd
# Check cluster status
kubectl cluster-info

# Check if pods are running
kubectl get pods

# Restart minikube if needed
minikube stop
minikube start
```

## Master Validation Script

The `validate-all-tasks.bat` script provides:
- **Interactive Menu**: Choose individual tasks or run all
- **Progress Tracking**: See completion status
- **Summary Report**: Overall project status
- **Quick Status**: Current cluster state

### Example Usage
```cmd
scripts\validate-all-tasks.bat
```

## Integration with Project

These scripts integrate with your project structure:
```
project/
├── scripts/
│   ├── task-validation/     # Individual task scripts
│   └── validate-all-tasks.bat  # Master validation script
├── k8s/                     # Kubernetes manifests (validated)
├── helm-charts/             # Helm charts (validated)
├── services/                # Source code (validated)
└── docs/                    # Documentation (validated)
```

## Continuous Validation

### Regular Checks
- Run after making changes to verify functionality
- Use before submitting project milestones
- Integrate with development workflow

### Automation
- Can be integrated with CI/CD pipelines
- Use for automated testing and validation
- Include in deployment verification steps

---

**Note**: These scripts are designed for Windows (`cmd.exe`) and validate a complete Kubernetes microservices project with Docker, Kubernetes, Helm, and CI/CD components.
