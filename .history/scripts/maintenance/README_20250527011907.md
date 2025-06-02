# Maintenance Scripts

🔄 **Keep your microservices updated, backed up, and optimized**

## Scripts in this folder:

### `update-images.bat`
- **Purpose**: Docker image management and updates
- **Usage**: `update-images.bat [--version tag] [--service name] [--rebuild]`
- **Features**:
  - Pull latest images from registry
  - Update to specific version tags
  - Rebuild and push updated images
  - Rolling update deployment
  - Rollback on failure

### `backup-config.bat`
- **Purpose**: Configuration backup and restore system
- **Usage**: `backup-config.bat [--restore backup-name]`
- **Features**:
  - Timestamped configuration backups
  - Kubernetes manifests backup
  - Helm values backup
  - ConfigMaps and Secrets backup
  - Automated restore procedures
  - Backup validation and verification

### `rollback-deployment.bat`
- **Purpose**: Rollback deployments and Helm releases
- **Usage**: `rollback-deployment.bat [service] [--revision number]`
- **Features**:
  - Interactive rollback menu
  - Kubernetes deployment rollbacks
  - Helm release rollbacks
  - Revision history viewing
  - Rollback validation
  - Status verification

### `cleanup-project.bat`
- **Purpose**: Complete project cleanup and removal
- **Usage**: `cleanup-project.bat [--force] [--namespace name]`
- **Features**:
  - Remove all deployments and services
  - Clean up Helm releases
  - Delete ConfigMaps and Secrets
  - Remove persistent volumes
  - Namespace cleanup
  - Docker image cleanup
  - Confirmation prompts for safety

## Usage Examples:

```batch
# Update all images to latest
scripts\maintenance\update-images.bat

# Update specific service to version
scripts\maintenance\update-images.bat --version v1.2.3 --service user-service

# Create configuration backup
scripts\maintenance\backup-config.bat

# Restore from backup
scripts\maintenance\backup-config.bat --restore backup-20241127-143022

# Interactive rollback menu
scripts\maintenance\rollback-deployment.bat

# Rollback specific service
scripts\maintenance\rollback-deployment.bat user-service --revision 2

# Complete project cleanup
scripts\maintenance\cleanup-project.bat
```

## Maintenance Operations:

### Image Management
- **Pull Latest** - Get newest versions from registry
- **Version Updates** - Update to specific version tags
- **Rebuild Images** - Rebuild from source with latest changes
- **Registry Push** - Push updated images to registry
- **Rolling Updates** - Zero-downtime deployment updates

### Backup & Restore
- **Configuration Backup** - Save all Kubernetes configurations
- **Helm Values Backup** - Preserve Helm chart values
- **Secret Backup** - Secure backup of sensitive data
- **Automated Restore** - One-click restoration procedures
- **Backup Validation** - Verify backup integrity

### Rollback Capabilities
- **Deployment Rollback** - Revert to previous deployment versions
- **Helm Rollback** - Revert Helm releases to previous revisions
- **Revision History** - View available rollback points
- **Selective Rollback** - Rollback individual services
- **Validation** - Verify rollback success

### Cleanup Operations
- **Resource Cleanup** - Remove all Kubernetes resources
- **Helm Cleanup** - Uninstall all Helm releases
- **Image Cleanup** - Remove unused Docker images
- **Storage Cleanup** - Clean up persistent volumes
- **Namespace Cleanup** - Remove entire namespaces

## Safety Features:

### Confirmation Prompts
- Destructive operations require confirmation
- Preview of actions before execution
- Option to cancel at any point
- Force mode for automation (use carefully)

### Backup Before Changes
- Automatic backup before major updates
- Rollback points before cleanup
- Configuration preservation
- Recovery procedures

### Validation Steps
- Post-operation health checks
- Service availability verification
- Configuration integrity checks
- Performance impact assessment

## Best Practices:

### Regular Maintenance
- **Weekly Image Updates** - Keep services current
- **Daily Backups** - Protect against data loss
- **Monthly Cleanup** - Remove unused resources
- **Quarterly Reviews** - Assess and optimize configurations

### Update Strategy
1. **Backup Current State** - Always backup before updates
2. **Test in Development** - Validate updates in dev environment
3. **Rolling Updates** - Use zero-downtime deployment methods
4. **Monitor After Updates** - Watch for issues post-deployment
5. **Quick Rollback** - Be ready to rollback if issues arise

### Cleanup Strategy
- Use staging environment for testing cleanup procedures
- Never cleanup production without backups
- Verify cleanup scope before execution
- Keep cleanup logs for audit trails

---
💡 **Tip**: Regular maintenance prevents major issues. Use backups liberally and test rollback procedures regularly.
