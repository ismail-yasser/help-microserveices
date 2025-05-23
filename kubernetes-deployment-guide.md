# Kubernetes Deployment Guide

This document provides complete instructions for deploying the microservices application to a Kubernetes cluster using Minikube.

## Prerequisites

- Docker installed and running
- Minikube installed
- kubectl configured to work with Minikube
- WSL2 (Windows Subsystem for Linux) recommended for Windows users

## Application Components

The application consists of three main services:

1. **Frontend**: React.js web interface
2. **User Service**: Handles user authentication and management
3. **Help Service**: Manages help requests and offerings

## Setup Instructions

### 1. Start Minikube

```bash
# Start Minikube
minikube start

# Verify Minikube status
minikube status
```

### 2. Build Docker Images

```bash
# Build the frontend image
docker build -t frontend:latest -f ./frontend/Dockerfile ./frontend

# Build the user-service image
docker build -t user-service:latest -f ./services/user-service/Dockerfile ./services/user-service

# Build the help-service image
docker build -t help-service:latest -f ./services/help-service/Dockerfile ./services/help-service
```

### 3. Load Images into Minikube

Run the provided script to load images:

```bash
.\scripts\load-images-to-minikube.bat
```

or manually load each image:

```bash
# Tag images for local use
docker tag frontend:latest frontend:local
docker tag user-service:latest user-service:local
docker tag help-service:latest help-service:local

# Load images into Minikube
minikube image load frontend:local
minikube image load user-service:local
minikube image load help-service:local
```

### 4. Apply Kubernetes Configurations

```bash
# Apply ConfigMaps and Secrets first
kubectl apply -f k8s/user-service-configmap.yaml
kubectl apply -f k8s/help-service-configmap.yaml
kubectl apply -f k8s/frontend-configmap.yaml
kubectl apply -f k8s/user-service-secret.yaml
kubectl apply -f k8s/help-service-secret.yaml

# Apply deployments and services
kubectl apply -f k8s/user-service-deployment.yaml
kubectl apply -f k8s/help-service-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/user-service.yaml
kubectl apply -f k8s/help-service.yaml
kubectl apply -f k8s/frontend-service.yaml

# Finally, apply the ingress rules
kubectl apply -f k8s/ingress.yaml
```

### 5. Add Host File Entries

Run the PowerShell script as Administrator:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\add-host-entries.ps1
```

Or manually add these entries to your hosts file (`C:\Windows\System32\drivers\etc\hosts`):

```
127.0.0.1 frontend.local
127.0.0.1 user-service.local
127.0.0.1 help-service.local
```

### 6. Set Up Port Forwarding

For local development without using the ingress:

```bash
# Frontend
kubectl port-forward service/frontend 8080:3001

# User Service
kubectl port-forward service/user-service 8081:3000

# Help Service
kubectl port-forward service/help-service 8082:3002
```

### 7. Validate Deployment

Run the validation script:

```bash
.\scripts\validate-deployment.bat
```

Or manually check each component:

```bash
# Check pods
kubectl get pods

# Check services
kubectl get services

# Check ingress
kubectl get ingress
```

## Troubleshooting

### 1. Connection Issues

If you encounter "connection refused" errors:

```bash
# Verify Minikube is running
minikube status

# Check kubectl configuration
kubectl config view --minify
kubectl config use-context minikube
```

### 2. Image Pull Errors

If pods show "ErrImagePull" status:

```bash
# Verify images are loaded in Minikube
minikube image ls | grep -E 'frontend|user-service|help-service'

# Check pod events
kubectl describe pod <pod-name>
```

### 3. ConfigMap and Secret Issues

```bash
# Verify ConfigMaps exist
kubectl get configmaps

# Verify Secrets exist
kubectl get secrets

# Check if pods can access ConfigMaps and Secrets
kubectl exec <pod-name> -- env
```

## Updating the Application

### 1. Update Docker Images

```bash
# Rebuild the service image
docker build -t <service-name>:latest -f ./<path-to-dockerfile> ./<service-directory>

# Tag for Minikube
docker tag <service-name>:latest <service-name>:local

# Load into Minikube
minikube image load <service-name>:local
```

### 2. Update the Deployment

```bash
# Update the deployment to use the new image
kubectl set image deployment/<deployment-name> <container-name>=<service-name>:local

# Or apply updated YAML files
kubectl apply -f k8s/<deployment-file>.yaml
```

### 3. Monitor Rollout

```bash
# Check rollout status
kubectl rollout status deployment/<deployment-name>

# If needed, rollback
kubectl rollout undo deployment/<deployment-name>
```
