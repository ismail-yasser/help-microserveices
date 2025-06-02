# Monitoring Scripts

📊 **Monitor, diagnose, and troubleshoot your microservices**

## Scripts in this folder:

### `check-status.bat`
- **Purpose**: Comprehensive system status overview
- **Usage**: `check-status.bat [namespace]`
- **Features**:
  - Deployment status and readiness
  - Pod health and resource usage
  - Service and endpoint verification
  - ConfigMap and Secret validation
  - HPA status and metrics

### `view-logs.bat`
- **Purpose**: Advanced log viewer with filtering
- **Usage**: `view-logs.bat [service] [options]`
- **Features**:
  - Service selection (user-service, help-service, frontend, all)
  - Time range filtering (1h, 24h, 7d, custom)
  - Output options (console, file, real-time streaming)
  - Error highlighting and filtering
  - Log export capabilities

### `monitor-resources.bat`
- **Purpose**: Resource monitoring and metrics
- **Usage**: `monitor-resources.bat [--continuous] [namespace]`
- **Features**:
  - Node resource usage (CPU, memory, disk)
  - Pod resource consumption
  - HPA metrics and status
  - Metrics server validation
  - Continuous monitoring mode

### `health-checks.bat`
- **Purpose**: Comprehensive 9-point health assessment
- **Usage**: `health-checks.bat [namespace]`
- **Features**:
  - Cluster connectivity verification
  - Deployment and pod health checks
  - Service availability testing
  - Endpoint connectivity validation
  - Configuration integrity checks
  - Resource usage analysis
  - Application health endpoints

### `troubleshoot.bat`
- **Purpose**: Comprehensive diagnostics and automated fixes
- **Usage**: `troubleshoot.bat [namespace]`
- **Features**:
  - System diagnostics (Docker, Kubernetes, Minikube)
  - Application diagnostics (pods, services, configs)
  - Network connectivity testing
  - Automated fix recommendations
  - Common issue resolution
  - Performance analysis

## Usage Examples:

```batch
# Quick status check
scripts\monitoring\check-status.bat

# View real-time logs for user-service
scripts\monitoring\view-logs.bat user-service --follow

# Monitor resources continuously
scripts\monitoring\monitor-resources.bat --continuous

# Run complete health assessment
scripts\monitoring\health-checks.bat

# Comprehensive troubleshooting
scripts\monitoring\troubleshoot.bat
```

## Monitoring Capabilities:

### System Health
- **Cluster Status** - Kubernetes cluster health
- **Node Resources** - CPU, memory, disk usage
- **Component Status** - Core Kubernetes components

### Application Health  
- **Deployment Status** - Replica availability and readiness
- **Pod Health** - Running status, restart counts, errors
- **Service Connectivity** - Endpoint availability and routing

### Performance Monitoring
- **Resource Usage** - Real-time CPU and memory consumption
- **HPA Metrics** - Autoscaling status and triggers
- **Log Analysis** - Error patterns and performance issues

### Troubleshooting Features
- **Automated Diagnostics** - Systematic issue detection
- **Fix Recommendations** - Actionable solution suggestions
- **Common Issues** - Known problems and solutions
- **Recovery Procedures** - Step-by-step recovery guides

## Log Viewing Options:

### Service Selection
- `user-service` - User management service logs
- `help-service` - Help and support service logs  
- `frontend` - Frontend application logs
- `all` - Combined logs from all services

### Time Ranges
- Last 1 hour, 24 hours, 7 days
- Custom time ranges
- Real-time streaming (`--follow`)

### Output Formats
- Console display with highlighting
- File export with timestamps
- Real-time streaming mode

## Health Check Categories:

1. **Cluster Connectivity** - Basic cluster access
2. **Deployment Status** - Application deployment health
3. **Pod Health** - Individual pod status
4. **Service Availability** - Service discovery and routing
5. **Endpoint Connectivity** - Network connectivity testing
6. **ConfigMap Validation** - Configuration integrity
7. **Resource Usage** - Performance and capacity
8. **HPA Status** - Autoscaling functionality  
9. **Application Health** - Application-specific health endpoints

---
💡 **Tip**: Use `health-checks.bat` regularly to catch issues early, and `troubleshoot.bat` when problems occur.
