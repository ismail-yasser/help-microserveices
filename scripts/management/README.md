# Management Scripts

🎛️ **Control the lifecycle of your microservices**

## Scripts in this folder:

### `manage-project.bat`
- **Purpose**: Interactive management console
- **Usage**: `manage-project.bat`
- **Features**:
  - 14 management operations in one interface
  - Status checking and monitoring
  - Service lifecycle control
  - Scaling and resource management
  - Backup and maintenance operations

### `start-services.bat`
- **Purpose**: Start all services
- **Usage**: `start-services.bat [namespace]`
- **Features**:
  - Scale all deployments to 2 replicas
  - Wait for pods to be ready
  - Verify service availability
  - Status reporting

### `stop-services.bat`
- **Purpose**: Stop all services
- **Usage**: `stop-services.bat [namespace]`
- **Features**:
  - Scale all deployments to 0 replicas
  - Graceful shutdown
  - Resource cleanup
  - Confirmation prompts for safety

### `restart-services.bat`
- **Purpose**: Rolling restart of all services
- **Usage**: `restart-services.bat [namespace]`
- **Features**:
  - Rolling restart (zero-downtime)
  - Wait for deployment readiness
  - Status verification
  - Restart history tracking

### `scale-services.bat`
- **Purpose**: Interactive scaling control
- **Usage**: `scale-services.bat [namespace]`
- **Features**:
  - Scale individual services (1-10 replicas)
  - Scale all services at once
  - Real-time status updates
  - HPA compatibility checks

## Usage Examples:

```batch
# Interactive management console
scripts\management\manage-project.bat

# Start all services
scripts\management\start-services.bat

# Stop services in production namespace
scripts\management\stop-services.bat production

# Rolling restart
scripts\management\restart-services.bat

# Interactive scaling
scripts\management\scale-services.bat
```

## Management Operations Available:

### Service Lifecycle
1. **Start Services** - Bring all services online
2. **Stop Services** - Gracefully shutdown all services  
3. **Restart Services** - Rolling restart without downtime
4. **Scale Services** - Adjust replica counts

### Status & Monitoring
5. **Check Status** - Comprehensive system overview
6. **View Logs** - Advanced log viewing and filtering
7. **Monitor Resources** - CPU, memory, and HPA status
8. **Health Checks** - 9-point health assessment

### Maintenance
9. **Update Images** - Docker image management
10. **Backup Config** - Configuration backup
11. **Rollback** - Deployment rollback capabilities
12. **Cleanup** - Project cleanup and removal

## Safety Features:
- Confirmation prompts for destructive operations
- Namespace isolation support
- Status verification after operations
- Error handling and recovery guidance

## Best Practices:
- Use `manage-project.bat` for daily operations
- Monitor services before/after changes
- Use namespaces for environment separation
- Regular backups before major changes

---
💡 **Tip**: The management console provides the most user-friendly interface for all operations.
