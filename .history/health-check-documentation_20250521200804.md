# Microservices Health Checks Implementation

This document summarizes the implementation of health checks in the microservices application.

## Project Structure

```
└── project/
    ├── deployment.yaml        # Kubernetes deployment file with health probes
    ├── service.yaml           # Kubernetes service definitions
    ├── test-pod.yaml          # Test pod for validating service connectivity
    ├── test-health-endpoints.js # JavaScript script for testing health endpoints
    ├── run-health-checks.bat  # Windows script for running health checks
    ├── run-health-checks.sh   # Linux/Bash script for running health checks
    ├── docker-compose.yml     # Docker Compose for local development
    ├── services/
    │   ├── user-service/      # User authentication and profile service
    │   │   ├── index.js       # Service entry point with health endpoint
    │   │   └── ...
    │   └── help-service/      # Help request/offer management service  
    │       ├── index.js       # Service entry point with health endpoint
    │       └── ...
    └── frontend/              # React frontend application
```

## Health Endpoints

Health endpoints have been implemented in both microservices:

1. **User Service**: `/api/health` endpoint (port 3000)
2. **Help Service**: `/api/health` endpoint (port 3002)

These endpoints return:
```json
{
  "status": "ok",
  "service": "<service-name>",
  "timestamp": "<iso-date>"
}
```

## Kubernetes Integration

The health endpoints are used in the Kubernetes deployment for:

1. **Liveness Probes**: Checks if the service is running and restarts if it's not
2. **Readiness Probes**: Ensures services only receive traffic when they're ready

## Testing

Health checks can be tested using the provided scripts:

### Windows
```bash
run-health-checks.bat [--local|--kubernetes] [--direct]
```

### Linux/Bash
```bash
./run-health-checks.sh [--local|--kubernetes] [--direct]
```

Options:
- `--local`: Test in local environment (localhost)
- `--kubernetes`: Test in Kubernetes cluster
- `--direct`: Use direct curl testing instead of the Node.js script

## Deployment

To deploy with health checks enabled:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

To validate connectivity between services:
```bash
# Using the validation scripts:
validate-services.bat    # Windows
./validate-services.sh   # Linux/macOS

# Or manually:
kubectl apply -f test-pod.yaml
kubectl exec -it service-test-pod -- nslookup user-service
kubectl exec -it service-test-pod -- nslookup help-service
kubectl exec -it service-test-pod -- curl http://user-service:3000/api/health
kubectl exec -it service-test-pod -- curl http://help-service:3002/api/health
```

## Service Architecture

Services in Kubernetes provide stable endpoints and DNS names for microservices.

- **ClusterIP Services**: `user-service` and `help-service` use ClusterIP type for internal
  cluster communication
- **Service Discovery**: Pods can communicate with other services using their DNS names
  (e.g., `http://user-service:3000/api/users`)
- **Health Integration**: Health endpoints are accessible via service DNS names,
  making them ideal for monitoring and health checks

See [kubernetes-services.md](kubernetes-services.md) for detailed information about the service architecture.
