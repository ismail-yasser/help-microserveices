# User Service Helm Chart - Complete Documentation

## Overview

This document provides comprehensive documentation for the User Service Helm chart, including installation, configuration, usage, and troubleshooting.

## Table of Contents

1. [Architecture](#architecture)
2. [Prerequisites](#prerequisites)
3. [Installation Guide](#installation-guide)
4. [Configuration](#configuration)
5. [Usage Examples](#usage-examples)
6. [Maintenance](#maintenance)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

## Architecture

The User Service Helm chart deploys the following Kubernetes resources:

```
┌─────────────────────────────────────────────────────────┐
│                    User Service                         │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │ Deployment  │ │   Service   │ │        HPA          │ │
│ │  (2-5 pods) │ │ (ClusterIP) │ │ (Auto-scaling)      │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
│                                                         │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │ ConfigMap   │ │   Secret    │ │ PodDisruptionBudget │ │
│ │ (App Config)│ │(Credentials)│ │   (Availability)    │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │                 Ingress (Optional)                  │ │
│ │              External Access                        │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

### Required Software

- **Kubernetes**: v1.16+ (tested with v1.25+)
- **Helm**: v3.2.0+ (recommended v3.8+)
- **kubectl**: Compatible with your Kubernetes cluster version

### Required Access

- Kubernetes cluster admin or sufficient RBAC permissions
- MongoDB Atlas or MongoDB cluster access
- Container registry access (for custom images)

### Cluster Requirements

- **CPU**: Minimum 2 cores available
- **Memory**: Minimum 2GB available
- **Storage**: For persistent volumes (if applicable)
- **Network**: Ingress controller (if using ingress)

## Installation Guide

### Method 1: Quick Installation (Development)

```bash
# Clone the repository
git clone <your-repo-url>
cd project/helm-charts/user-service

# Install with minimal configuration
helm install user-service . \
  --set secret.MONGO_URI="mongodb+srv://user:pass@cluster.mongodb.net/db" \
  --set secret.JWT_SECRET="your-jwt-secret" \
  --namespace development \
  --create-namespace
```

### Method 2: Using Installation Script

```bash
# Make the script executable (Windows)
cd helm-charts\user-service
install-helm-chart.bat development user-service-dev

# Follow the prompts for MongoDB URI and JWT Secret
```

### Method 3: Production Deployment

```bash
# 1. Create production values file
cp values-production.yaml my-production-values.yaml

# 2. Edit the values file with your configuration
# nano my-production-values.yaml

# 3. Install with production settings
helm install user-service-prod . \
  -f my-production-values.yaml \
  --set secret.MONGO_URI="$PROD_MONGO_URI" \
  --set secret.JWT_SECRET="$PROD_JWT_SECRET" \
  --namespace production \
  --create-namespace
```

### Method 4: GitOps Approach

Create a values file in your GitOps repository:

```yaml
# my-environment-values.yaml
replicaCount: 3
image:
  tag: "v1.2.0"
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
```

Apply using ArgoCD, Flux, or similar GitOps tools.

## Configuration

### Core Configuration Options

#### Image Configuration
```yaml
image:
  repository: ismaill370/user-service  # Docker image repository
  pullPolicy: IfNotPresent             # Image pull policy
  tag: "latest"                        # Image tag (overrides appVersion)

imagePullSecrets: []                   # For private registries
```

#### Scaling Configuration
```yaml
replicaCount: 2                        # Static replica count (if HPA disabled)

autoscaling:
  enabled: true                        # Enable Horizontal Pod Autoscaler
  minReplicas: 2                       # Minimum number of pods
  maxReplicas: 5                       # Maximum number of pods
  targetCPUUtilizationPercentage: 70   # CPU threshold for scaling
  # targetMemoryUtilizationPercentage: 80  # Memory threshold (optional)
```

#### Resource Management
```yaml
resources:
  limits:
    cpu: 500m                          # Maximum CPU (millicores)
    memory: 512Mi                      # Maximum memory
  requests:
    cpu: 100m                          # Requested CPU
    memory: 128Mi                      # Requested memory
```

#### Service Configuration
```yaml
service:
  type: ClusterIP                      # Service type (ClusterIP, NodePort, LoadBalancer)
  port: 3000                          # Service port
  targetPort: 3000                    # Container port
```

### Environment-Specific Configurations

#### Development Environment
```yaml
# values-development.yaml
replicaCount: 1
image:
  pullPolicy: Always
  tag: "latest"
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 256Mi
configMap:
  NODE_ENV: 'development'
  LOG_LEVEL: 'debug'
```

#### Production Environment
```yaml
# values-production.yaml
replicaCount: 3
image:
  pullPolicy: IfNotPresent
  tag: "v1.0.0"                       # Specific version tag
resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 1Gi
configMap:
  NODE_ENV: 'production'
  LOG_LEVEL: 'warn'
  CORS_ORIGIN: 'https://yourdomain.com'
podDisruptionBudget:
  enabled: true
  minAvailable: 2
```

### Security Configuration

#### Secrets Management
```yaml
secret:
  MONGO_URI: "mongodb+srv://..."       # Required: MongoDB connection string
  JWT_SECRET: "your-secret-key"        # Required: JWT signing key
```

#### Pod Security
```yaml
podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 2000

securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - ALL
```

### Networking Configuration

#### Ingress Setup
```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: user-service.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: user-service-tls
      hosts:
        - user-service.yourdomain.com
```

#### Network Policies
```yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
      - namespaceSelector:
          matchLabels:
            name: frontend
      ports:
      - protocol: TCP
        port: 3000
```

## Usage Examples

### Basic Operations

#### Check Deployment Status
```bash
# List all releases
helm list -A

# Get release status
helm status user-service -n development

# Check pods
kubectl get pods -n development -l app.kubernetes.io/name=user-service

# Check service
kubectl get svc -n development user-service
```

#### View Configuration
```bash
# Get current values
helm get values user-service -n development

# Get all applied manifests
helm get manifest user-service -n development
```

#### Access the Service
```bash
# Port forward for local access
kubectl port-forward -n development svc/user-service 3000:3000

# Test health endpoint
curl http://localhost:3000/health

# Test readiness endpoint
curl http://localhost:3000/ready
```

### Advanced Operations

#### Rolling Updates
```bash
# Update image tag
helm upgrade user-service . \
  --set image.tag="v1.1.0" \
  --namespace development

# Update configuration
helm upgrade user-service . \
  -f my-new-values.yaml \
  --namespace development
```

#### Rollback
```bash
# View history
helm history user-service -n development

# Rollback to previous version
helm rollback user-service -n development

# Rollback to specific revision
helm rollback user-service 2 -n development
```

#### Scaling
```bash
# Manual scaling (when HPA is disabled)
kubectl scale deployment user-service --replicas=5 -n development

# Update HPA settings
helm upgrade user-service . \
  --set autoscaling.maxReplicas=10 \
  --namespace development
```

### Testing

#### Helm Tests
```bash
# Run built-in tests
helm test user-service -n development

# Clean up test pods
kubectl delete pod user-service-test -n development
```

#### Load Testing
```bash
# Simple load test with curl
for i in {1..100}; do
  curl -s http://localhost:3000/health > /dev/null
  echo "Request $i completed"
done

# Watch HPA during load test
kubectl get hpa -w -n development
```

## Maintenance

### Regular Maintenance Tasks

#### 1. Updates and Upgrades
```bash
# Check for new chart versions
helm repo update

# Upgrade to latest chart version
helm upgrade user-service . --namespace development

# Update image to latest version
helm upgrade user-service . \
  --set image.tag="latest" \
  --namespace development
```

#### 2. Backup and Recovery
```bash
# Backup current configuration
helm get values user-service -n development > backup-values.yaml

# Export all resources
kubectl get all -n development -l app.kubernetes.io/name=user-service -o yaml > backup-resources.yaml
```

#### 3. Monitoring and Alerting
```bash
# Check resource usage
kubectl top pods -n development -l app.kubernetes.io/name=user-service

# View metrics (if metrics-server installed)
kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/development/pods

# Check HPA status
kubectl describe hpa user-service-hpa -n development
```

### Scheduled Maintenance

#### Monthly Tasks
- Review and update resource limits based on usage patterns
- Update to latest stable image versions
- Review and rotate secrets (JWT secrets, etc.)
- Clean up old Helm releases and revisions

#### Quarterly Tasks
- Review security policies and update pod security contexts
- Evaluate autoscaling parameters and adjust based on traffic patterns
- Update Helm chart to latest version
- Conduct disaster recovery testing

## Troubleshooting

### Common Issues and Solutions

#### 1. Pods Not Starting

**Symptoms:**
```bash
kubectl get pods -n development
# Shows pods in Pending or CrashLoopBackOff state
```

**Diagnosis:**
```bash
# Check pod details
kubectl describe pod <pod-name> -n development

# Check events
kubectl get events -n development --sort-by=.metadata.creationTimestamp

# Check logs
kubectl logs <pod-name> -n development
```

**Common Causes and Solutions:**

- **Insufficient resources**: Increase cluster capacity or reduce resource requests
- **Image pull errors**: Check image name, tag, and registry access
- **Secret missing**: Ensure MONGO_URI and JWT_SECRET are properly set
- **ConfigMap issues**: Verify ConfigMap was created correctly

#### 2. MongoDB Connection Issues

**Symptoms:**
```bash
kubectl logs <pod-name> -n development
# Shows MongoDB connection timeouts or authentication errors
```

**Solutions:**
```bash
# Verify MongoDB URI format
echo $MONGO_URI | base64 -d

# Test connection from within pod
kubectl exec -it <pod-name> -n development -- /bin/sh
# Inside pod: curl -v telnet://cluster.mongodb.net:27017

# Check DNS resolution
kubectl exec -it <pod-name> -n development -- nslookup cluster.mongodb.net
```

#### 3. Service Not Accessible

**Symptoms:**
```bash
kubectl get svc -n development
# Service exists but cannot connect
```

**Diagnosis:**
```bash
# Check service endpoints
kubectl get endpoints -n development user-service

# Test service from within cluster
kubectl run debug --image=busybox --rm -it --restart=Never -- /bin/sh
# Inside pod: wget -qO- http://user-service.development:3000/health
```

#### 4. HPA Not Scaling

**Symptoms:**
```bash
kubectl get hpa -n development
# HPA shows UNKNOWN for CPU metrics
```

**Solutions:**
```bash
# Check metrics-server
kubectl get pods -n kube-system | grep metrics-server

# Verify resource requests are set (required for HPA)
kubectl describe deployment user-service -n development | grep -A 10 Requests

# Check HPA events
kubectl describe hpa user-service-hpa -n development
```

### Debug Commands

#### Comprehensive Health Check
```bash
#!/bin/bash
# Health check script

NAMESPACE="development"
RELEASE="user-service"

echo "=== Helm Release Status ==="
helm status $RELEASE -n $NAMESPACE

echo -e "\n=== Pods ==="
kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=user-service

echo -e "\n=== Services ==="
kubectl get svc -n $NAMESPACE $RELEASE

echo -e "\n=== HPA ==="
kubectl get hpa -n $NAMESPACE

echo -e "\n=== Events ==="
kubectl get events -n $NAMESPACE --sort-by=.metadata.creationTimestamp | tail -10

echo -e "\n=== Pod Logs (last 20 lines) ==="
kubectl logs -n $NAMESPACE -l app.kubernetes.io/name=user-service --tail=20
```

#### Network Connectivity Test
```bash
# Test internal connectivity
kubectl run netshoot --image=nicolaka/netshoot --rm -it --restart=Never -- /bin/bash

# Inside netshoot:
# Test DNS resolution
nslookup user-service.development.svc.cluster.local

# Test HTTP connectivity
curl -v http://user-service.development:3000/health

# Test MongoDB connectivity (if URI is available)
curl -v telnet://cluster.mongodb.net:27017
```

## Best Practices

### Security Best Practices

1. **Use Specific Image Tags**
   ```yaml
   image:
     tag: "v1.0.0"  # Instead of "latest"
   ```

2. **Set Resource Limits**
   ```yaml
   resources:
     limits:
       cpu: 500m
       memory: 512Mi
     requests:
       cpu: 100m
       memory: 128Mi
   ```

3. **Use Pod Security Contexts**
   ```yaml
   securityContext:
     runAsNonRoot: true
     readOnlyRootFilesystem: true
   ```

4. **Rotate Secrets Regularly**
   ```bash
   # Update JWT secret
   helm upgrade user-service . \
     --set secret.JWT_SECRET="new-secret-key" \
     --namespace production
   ```

### Operational Best Practices

1. **Use Environment-Specific Values Files**
   ```bash
   # Development
   helm install user-service . -f values-development.yaml

   # Production
   helm install user-service . -f values-production.yaml
   ```

2. **Enable Pod Disruption Budgets in Production**
   ```yaml
   podDisruptionBudget:
     enabled: true
     minAvailable: 2
   ```

3. **Set Up Proper Monitoring**
   ```yaml
   # Add monitoring annotations
   podAnnotations:
     prometheus.io/scrape: "true"
     prometheus.io/port: "3000"
     prometheus.io/path: "/metrics"
   ```

4. **Use Horizontal Pod Autoscaling**
   ```yaml
   autoscaling:
     enabled: true
     minReplicas: 2
     maxReplicas: 10
     targetCPUUtilizationPercentage: 70
   ```

### Development Best Practices

1. **Use Helm Lint and Template**
   ```bash
   # Validate chart
   helm lint .

   # Preview templates
   helm template user-service . --debug
   ```

2. **Test Changes in Development**
   ```bash
   # Dry run
   helm install user-service . --dry-run --debug

   # Install in test namespace
   helm install test-user-service . --namespace test --create-namespace
   ```

3. **Version Your Charts**
   ```yaml
   # Chart.yaml
   version: 0.2.0
   appVersion: "v1.1.0"
   ```

4. **Document Changes**
   ```bash
   # Use semantic versioning for releases
   git tag v1.1.0
   helm package . --version 1.1.0
   ```

This concludes the comprehensive documentation for the User Service Helm chart. The chart is now production-ready with proper templating, configuration options, and operational scripts.
