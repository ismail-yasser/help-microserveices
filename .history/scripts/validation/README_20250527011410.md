# Validation Scripts

🧪 **Test and validate your deployments and configurations**

## Scripts in this folder:

### `validate-all-tasks.bat`
- **Purpose**: Comprehensive validation of all project tasks
- **Usage**: `validate-all-tasks.bat [--verbose] [--report]`
- **Features**:
  - Validates all 17 project tasks
  - Comprehensive deployment testing
  - Configuration validation
  - Service connectivity testing
  - Performance validation
  - Detailed reporting

### `validate-individual-tasks.bat`
- **Purpose**: Validate specific project tasks individually
- **Usage**: `validate-individual-tasks.bat [task-number]`
- **Features**:
  - Interactive task selection
  - Individual task validation
  - Detailed error reporting
  - Fix recommendations
  - Progress tracking

### `validate-team-tasks.bat`
- **Purpose**: Team-specific validation scenarios
- **Usage**: `validate-team-tasks.bat [team] [--environment env]`
- **Features**:
  - Team-based validation suites
  - Environment-specific tests
  - Collaborative validation
  - Team performance metrics
  - Integration testing

### `validate-helm-deployment.sh`
- **Purpose**: Helm deployment validation (Linux/WSL)
- **Usage**: `validate-helm-deployment.sh [chart-name] [namespace]`
- **Features**:
  - Helm chart validation
  - Release health checking
  - Values validation
  - Template rendering tests
  - Deployment verification

### Task Validation Scripts (`task-validation/`)
Individual validation scripts for each project task:
- `01-check-docker-images.bat` - Docker image validation
- `02-check-deployments.bat` - Deployment status validation
- `03-check-services.bat` - Service configuration validation
- `04-check-configmaps-secrets.bat` - Configuration validation
- `05-check-api-documentation.bat` - API documentation validation
- `06-check-load-balancing.bat` - Load balancing validation
- `07-check-github-repo.bat` - Repository structure validation
- `08-check-health-probes.bat` - Health probe validation
- `09-check-hpa.bat` - Horizontal Pod Autoscaler validation
- `10-check-frontend-deployment.bat` - Frontend deployment validation
- `11-check-frontend-exposure.bat` - Frontend exposure validation
- `12-check-integration-testing.bat` - Integration test validation
- `13-check-architecture-diagram.bat` - Architecture documentation validation
- `14-check-k8s-organization.bat` - Kubernetes organization validation
- `15-check-ingress-controller.bat` - Ingress controller validation
- `16-check-github-actions.bat` - CI/CD pipeline validation
- `17-check-helm-chart.bat` - Helm chart validation

## Usage Examples:

```batch
# Validate all project tasks
scripts\validation\validate-all-tasks.bat

# Validate specific task
scripts\validation\validate-individual-tasks.bat 5

# Team validation suite
scripts\validation\validate-team-tasks.bat frontend-team --environment production

# Helm deployment validation (in WSL)
scripts\validation\validate-helm-deployment.sh user-service production

# Individual task validation
scripts\validation\task-validation\01-check-docker-images.bat
```

## Validation Categories:

### Infrastructure Validation
- **Docker Images** - Image availability and integrity
- **Kubernetes Cluster** - Cluster health and connectivity
- **Namespaces** - Proper namespace configuration
- **Storage** - Persistent volume validation

### Deployment Validation
- **Deployments** - Replica availability and readiness
- **Services** - Service discovery and routing
- **ConfigMaps/Secrets** - Configuration integrity
- **Ingress** - External access configuration

### Application Validation
- **Health Probes** - Liveness and readiness checks
- **API Endpoints** - Service functionality testing
- **Load Balancing** - Traffic distribution validation
- **Integration Testing** - End-to-end functionality

### Performance Validation
- **Resource Usage** - CPU and memory consumption
- **HPA Functionality** - Autoscaling behavior
- **Response Times** - Performance benchmarking
- **Load Testing** - Stress testing capabilities

### Documentation Validation
- **API Documentation** - Endpoint documentation completeness
- **Architecture Diagrams** - System architecture documentation
- **README Files** - Documentation accuracy and completeness
- **Code Comments** - Code documentation quality

## Validation Levels:

### Basic Validation (Quick)
- Essential service availability
- Basic connectivity testing
- Core functionality verification
- ~5 minutes execution time

### Standard Validation (Comprehensive)
- Full deployment validation
- Configuration integrity checks
- Performance baseline testing
- ~15 minutes execution time

### Extended Validation (Complete)
- Full integration testing
- Performance stress testing
- Security validation
- Documentation completeness
- ~30-45 minutes execution time

## Validation Reports:

### Console Output
- Real-time validation progress
- Color-coded status indicators
- Immediate error feedback
- Summary statistics

### File Reports
- Detailed validation logs
- Timestamped results
- Error details and recommendations
- Performance metrics

### CI/CD Integration
- JUnit-style XML reports
- GitHub Actions integration
- Automated validation triggers
- Build status integration

## Common Validation Scenarios:

### Pre-Deployment Validation
```batch
# Before deploying to production
scripts\validation\validate-all-tasks.bat --environment production
```

### Post-Deployment Validation
```batch
# After deployment verification
scripts\validation\validate-team-tasks.bat all --environment production
```

### Development Validation
```batch
# During development
scripts\validation\validate-individual-tasks.bat
```

### CI/CD Pipeline Validation
```batch
# Automated pipeline validation
scripts\validation\validate-all-tasks.bat --report --verbose
```

## Troubleshooting Validation Issues:

### Common Issues
- **Network Connectivity** - Check cluster access and DNS
- **Resource Constraints** - Verify sufficient resources
- **Configuration Errors** - Validate YAML syntax and values
- **Timing Issues** - Allow sufficient time for pod startup

### Debug Mode
```batch
# Enable verbose output for debugging
scripts\validation\validate-all-tasks.bat --verbose --debug
```

### Manual Verification
```batch
# Manual checks when validation fails
kubectl get pods,services,deployments
kubectl describe deployment [deployment-name]
kubectl logs [pod-name]
```

---
💡 **Tip**: Run validation regularly during development and always before production deployments to catch issues early.
