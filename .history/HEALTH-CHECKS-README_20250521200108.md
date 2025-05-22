# Microservices Health Check Implementation

## Overview

This document explains how health checks are implemented in our microservices architecture. Health checks are crucial for:

- Kubernetes readiness and liveness probes
- Service monitoring
- Infrastructure automation
- Simple status verification

## Available Scripts

Several scripts have been created to help test and verify health endpoints:

1. **run-health-checks.bat** - Windows script with multiple options for testing health endpoints
2. **run-health-checks.sh** - Linux/Bash version with same functionality
3. **check-docker-health.bat** - Quick check for locally running Docker containers
4. **install-test-dependencies.bat** - Installs the necessary dependencies for test scripts
5. **test-health-endpoints.js** - Underlying JavaScript test implementation

## Health Endpoints

Each microservice exposes a health endpoint:

- User Service: `http://user-service:3000/api/health`
- Help Service: `http://help-service:3002/api/health`

These endpoints return a consistent JSON response:

```json
{
  "status": "ok",
  "service": "user-service|help-service",
  "timestamp": "2025-05-21T09:30:00.000Z"
}
```

## How to Test

### In Kubernetes

1. Make sure the test pod is running:
   ```cmd
   kubectl apply -f test-pod.yaml
   ```

2. Test user-service:
   ```cmd
   kubectl exec -it service-test-pod -- curl http://user-service:3000/api/health
   ```

3. Test help-service:
   ```cmd
   kubectl exec -it service-test-pod -- curl http://help-service:3002/api/health
   ```

### Using the Test Scripts

Windows:
```cmd
run-health-checks.bat [--local|--kubernetes] [--direct]
```

Linux/Bash:
```bash
./run-health-checks.sh [--local|--kubernetes] [--direct]
```

Options:
- `--local`: Test in local environment (localhost)
- `--kubernetes`: Test in Kubernetes cluster
- `--direct`: Use direct curl testing instead of the Node.js script

## How to Use in Kubernetes

The health endpoints are configured in the Kubernetes deployment for:

1. **Liveness Probes**: To determine if a container is running and healthy
   - If it fails, Kubernetes restarts the container

2. **Readiness Probes**: To determine if a container is ready to accept traffic
   - If it fails, no traffic will be sent to the pod

Example configuration (already in deployment.yaml):

```yaml
livenessProbe:
  httpGet:
    path: /api/health
    port: 3000
  initialDelaySeconds: 30
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /api/health
    port: 3000
  initialDelaySeconds: 15
  periodSeconds: 5
```

## Implementation Details

Both health endpoints are implemented in the respective service's `index.js` file as a simple Express route:

```javascript
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    service: 'service-name',
    timestamp: new Date().toISOString()
  });
});
```

## Troubleshooting

If health checks are failing:

1. Check that the services are running:
   ```cmd
   kubectl get pods
   ```

2. Check service logs:
   ```cmd
   kubectl logs deployment/user-service-deployment
   kubectl logs deployment/help-service-deployment
   ```

3. Verify DNS resolution:
   ```cmd
   kubectl exec -it service-test-pod -- nslookup user-service
   kubectl exec -it service-test-pod -- nslookup help-service
   ```

4. Check connectivity with telnet:
   ```cmd
   kubectl exec -it service-test-pod -- telnet user-service 3000
   kubectl exec -it service-test-pod -- telnet help-service 3002
   ```
