# User Service Helm Chart

This Helm chart deploys the User Service microservice to a Kubernetes cluster.

## Description

The User Service provides user authentication and profile management functionality for the microservices application. It includes:

- User registration and authentication
- JWT token management
- MongoDB integration
- Health and readiness endpoints
- Horizontal Pod Autoscaling
- Configurable environment settings

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+
- MongoDB Atlas connection (or MongoDB cluster)
- Container registry access (for Docker images)

## Installation

### Quick Start

1. **Add the chart repository** (if using a Helm repository):
   ```bash
   helm repo add myrepo https://your-helm-repo.com
   helm repo update
   ```

2. **Install with default values**:
   ```bash
   helm install user-service ./helm-charts/user-service \
     --set secret.MONGO_URI="mongodb+srv://username:password@cluster.mongodb.net/database" \
     --set secret.JWT_SECRET="your-super-secret-jwt-key"
   ```

### Production Installation

For production deployments, use the production values file:

```bash
helm install user-service ./helm-charts/user-service \
  -f ./helm-charts/user-service/values-production.yaml \
  --set secret.MONGO_URI="mongodb+srv://username:password@cluster.mongodb.net/database" \
  --set secret.JWT_SECRET="your-super-secret-jwt-key" \
  --namespace production \
  --create-namespace
```

### Development Installation

For development environments:

```bash
helm install user-service-dev ./helm-charts/user-service \
  -f ./helm-charts/user-service/values-development.yaml \
  --set secret.MONGO_URI="mongodb+srv://username:password@cluster.mongodb.net/database" \
  --set secret.JWT_SECRET="your-development-jwt-key" \
  --namespace development \
  --create-namespace
```

## Configuration

### Required Parameters

| Parameter           | Description               | Example                                          |
| ------------------- | ------------------------- | ------------------------------------------------ |
| `secret.MONGO_URI`  | MongoDB connection string | `mongodb+srv://user:pass@cluster.mongodb.net/db` |
| `secret.JWT_SECRET` | JWT signing secret        | `your-secret-key-here`                           |

### Common Configuration Options

| Parameter                 | Description                | Default                   |
| ------------------------- | -------------------------- | ------------------------- |
| `replicaCount`            | Number of replicas         | `2`                       |
| `image.repository`        | Container image repository | `ismaill370/user-service` |
| `image.tag`               | Container image tag        | `latest`                  |
| `service.type`            | Kubernetes service type    | `ClusterIP`               |
| `service.port`            | Service port               | `3000`                    |
| `autoscaling.enabled`     | Enable HPA                 | `true`                    |
| `autoscaling.minReplicas` | Minimum replicas           | `2`                       |
| `autoscaling.maxReplicas` | Maximum replicas           | `5`                       |

### Advanced Configuration

#### Resource Limits
```yaml
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

#### Ingress Configuration
```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
  hosts:
    - host: user-service.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
```

#### Environment Variables
```yaml
configMap:
  NODE_ENV: 'production'
  LOG_LEVEL: 'info'
  CORS_ORIGIN: 'https://yourdomain.com'
  RATE_LIMIT_MAX: '1000'
```

## Upgrading

To upgrade an existing installation:

```bash
helm upgrade user-service ./helm-charts/user-service \
  --set secret.MONGO_URI="mongodb+srv://username:password@cluster.mongodb.net/database" \
  --set secret.JWT_SECRET="your-super-secret-jwt-key"
```

## Uninstallation

To uninstall the chart:

```bash
helm uninstall user-service
```

## Monitoring and Health Checks

The service exposes the following endpoints:

- `/health` - Liveness probe endpoint
- `/ready` - Readiness probe endpoint
- `/api/users/*` - API endpoints

### Checking Status

```bash
# Check pods
kubectl get pods -l app.kubernetes.io/name=user-service

# Check service
kubectl get svc user-service

# Check HPA (if enabled)
kubectl get hpa user-service-hpa

# View logs
kubectl logs -l app.kubernetes.io/name=user-service -f
```

## Testing

Run Helm tests to verify the deployment:

```bash
helm test user-service
```

## Troubleshooting

### Common Issues

1. **Pods not starting**: Check if secrets are properly configured
   ```bash
   kubectl describe pod -l app.kubernetes.io/name=user-service
   ```

2. **MongoDB connection issues**: Verify the MONGO_URI and network connectivity
   ```bash
   kubectl logs -l app.kubernetes.io/name=user-service
   ```

3. **Image pull errors**: Ensure the Docker image exists and is accessible
   ```bash
   kubectl get events --sort-by=.metadata.creationTimestamp
   ```

### Debugging Commands

```bash
# Get all resources created by the chart
kubectl get all -l app.kubernetes.io/name=user-service

# Check ConfigMap
kubectl get configmap user-service-config -o yaml

# Check Secret (base64 encoded)
kubectl get secret user-service-secret -o yaml

# Port forward for local testing
kubectl port-forward svc/user-service 3000:3000
```

## Development

### Local Testing

1. Install the chart in a test namespace:
   ```bash
   helm install test-user-service ./helm-charts/user-service \
     --namespace test \
     --create-namespace \
     --set secret.MONGO_URI="your-test-mongo-uri" \
     --set secret.JWT_SECRET="test-secret"
   ```

2. Test the endpoints:
   ```bash
   kubectl port-forward svc/test-user-service 3000:3000 -n test
   curl http://localhost:3000/health
   ```

### Chart Development

1. Validate the chart:
   ```bash
   helm lint ./helm-charts/user-service
   ```

2. Generate templates for inspection:
   ```bash
   helm template user-service ./helm-charts/user-service \
     --set secret.MONGO_URI="test" \
     --set secret.JWT_SECRET="test"
   ```

3. Dry run installation:
   ```bash
   helm install user-service ./helm-charts/user-service \
     --dry-run \
     --set secret.MONGO_URI="test" \
     --set secret.JWT_SECRET="test"
   ```

## Support

For issues and questions:

- Check the [troubleshooting section](#troubleshooting)
- Review pod logs: `kubectl logs -l app.kubernetes.io/name=user-service`
- Examine events: `kubectl get events --sort-by=.metadata.creationTimestamp`

## License

This chart is part of the microservices-k8s project.
