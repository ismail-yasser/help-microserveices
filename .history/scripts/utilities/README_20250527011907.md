# Utility Scripts

🌐 **Helper tools and utilities for project management**

## Scripts in this folder:

### `get-service-urls.bat`
- **Purpose**: Smart URL discovery for accessing services
- **Usage**: `get-service-urls.bat [namespace] [--output format]`
- **Features**:
  - Automatic environment detection (Minikube vs Cloud)
  - Service URL discovery and validation
  - LoadBalancer and NodePort support
  - Ingress URL detection
  - Port forwarding setup
  - Access method recommendations

## Service Access Methods:

### Minikube Environment
- **NodePort Services** - Direct node access via Minikube IP
- **Port Forwarding** - kubectl port-forward for development
- **Minikube Service** - Built-in service URL generation
- **Ingress** - Local ingress controller access

### Cloud Environment (GKE/EKS/AKS)
- **LoadBalancer** - External IP access via cloud load balancers
- **Ingress** - Domain-based routing via ingress controllers
- **NodePort** - Direct node access (when LoadBalancer unavailable)
- **Port Forwarding** - Secure local access

## Usage Examples:

```batch
# Get all service URLs
scripts\utilities\get-service-urls.bat

# Get URLs for specific namespace
scripts\utilities\get-service-urls.bat production

# Get URLs with detailed output
scripts\utilities\get-service-urls.bat --output detailed

# Get URLs in JSON format for automation
scripts\utilities\get-service-urls.bat --output json
```

## Output Formats:

### Standard Output
```
Service URLs:
=============
Frontend:     http://192.168.49.2:30080
User Service: http://192.168.49.2:30081/api
Help Service: http://192.168.49.2:30082/api

Access Methods:
- Browser: Open URLs directly
- API Testing: Use Postman or curl
- Port Forward: kubectl port-forward svc/frontend 8080:80
```

### Detailed Output
```
Detailed Service Information:
=============================

Frontend Service:
- Type: NodePort
- Cluster IP: 10.96.123.45
- External IP: 192.168.49.2:30080
- Ports: 80:30080/TCP
- Selector: app=frontend
- Endpoints: 2 ready pods
- Health: ✓ Healthy

User Service:
- Type: ClusterIP  
- Cluster IP: 10.96.234.56
- Port Forward: kubectl port-forward svc/user-service 3000:3000
- Ports: 3000/TCP
- Selector: app=user-service
- Endpoints: 3 ready pods
- Health: ✓ Healthy
```

### JSON Output (for automation)
```json
{
  "services": [
    {
      "name": "frontend",
      "type": "NodePort",
      "url": "http://192.168.49.2:30080",
      "internal_ip": "10.96.123.45",
      "ports": ["80:30080/TCP"],
      "ready_endpoints": 2,
      "health": "healthy"
    }
  ],
  "environment": "minikube",
  "cluster_ip": "192.168.49.2"
}
```

## Features:

### Intelligent Detection
- **Environment Detection** - Automatically detects Minikube, GKE, EKS, AKS
- **Service Type Detection** - Identifies LoadBalancer, NodePort, ClusterIP
- **Ingress Detection** - Finds ingress controllers and rules
- **Health Checking** - Validates service availability

### Access Recommendations
- **Best Access Method** - Recommends optimal access approach
- **Port Forwarding Setup** - Provides exact kubectl commands
- **Browser Ready URLs** - Direct browser-accessible URLs
- **API Testing Ready** - URLs formatted for API testing tools

### Multi-Environment Support
- **Development** - Local development access methods
- **Staging** - Staging environment specific configurations
- **Production** - Production-safe access methods
- **Custom** - Flexible configuration for custom setups

## Common Use Cases:

### Development Access
```batch
# Quick access during development
scripts\utilities\get-service-urls.bat

# Copy URLs for browser testing
scripts\utilities\get-service-urls.bat --output simple
```

### API Testing
```batch
# Get API endpoints for Postman
scripts\utilities\get-service-urls.bat development --output api

# Export URLs for automated testing
scripts\utilities\get-service-urls.bat --output json > service-urls.json
```

### Production Monitoring
```batch
# Check production service access
scripts\utilities\get-service-urls.bat production --output detailed

# Validate all service endpoints
scripts\utilities\get-service-urls.bat production --validate
```

### CI/CD Integration
```batch
# Get URLs for automated testing
scripts\utilities\get-service-urls.bat test --output json

# Validate service availability in pipeline
scripts\utilities\get-service-urls.bat --health-check
```

## Integration with Other Scripts:

### Used by Management Scripts
- Service health checking
- URL validation in monitoring
- Access verification in troubleshooting

### Used by Monitoring Scripts
- Endpoint availability testing
- Service connectivity validation
- Health check URL discovery

### Used by Deployment Scripts
- Post-deployment verification
- Service exposure validation
- Access method setup

## Troubleshooting Service Access:

### Common Issues
- **Service Not Found** - Check if services are deployed
- **Connection Refused** - Verify pod readiness and health
- **Wrong URLs** - Validate service type and configuration
- **Network Issues** - Check cluster networking and firewall

### Debug Commands
```batch
# Manual service checking
kubectl get services
kubectl get endpoints
kubectl describe service [service-name]

# Network debugging
kubectl run debug --image=busybox --rm -it -- nslookup [service-name]
```

---
💡 **Tip**: This utility is essential for accessing your services. Bookmark the URLs it provides for quick development access.
