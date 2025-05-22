# Docker Desktop and Kubernetes Troubleshooting Guide

This guide and the accompanying scripts are designed to help you resolve the issues you're experiencing with Docker Desktop crashing with "exit status 1" and Kubernetes connection problems.

## Troubleshooting Scripts

### 1. Diagnostic Scripts

- **`check-port-conflicts.bat`**: Identifies processes using Docker and Kubernetes ports
  - Use this first to detect if port conflicts are causing Docker or Kubernetes issues
  - If conflicts are found, you can kill the processes using the displayed PID

- **`collect-docker-logs.bat`**: Gathers Docker Desktop logs and system information
  - Use when you need to troubleshoot persistent Docker Desktop crashes
  - Creates a logs directory on your Desktop with all relevant information

### 2. Resolution Scripts

- **`fix-docker-desktop.bat`**: Performs comprehensive Docker Desktop troubleshooting
  - Stops all Docker services
  - Clears Docker data and settings (with backup)
  - Resets Docker network
  - Cleans Kubernetes configuration
  - Recommended as your first solution attempt

- **`restart-docker-kubernetes.bat`**: Properly restarts Docker Desktop and Kubernetes
  - Safely stops Docker processes
  - Restarts Docker with appropriate settings for Kubernetes
  - Use when Docker is installed but not starting correctly

- **`optimize-docker-settings.bat`**: Optimizes Docker Desktop settings for Kubernetes
  - Automatically configures optimal CPU, memory, and swap settings
  - Enables WSL2 backend if available
  - Creates backup of existing settings

- **`reinstall-docker-desktop.bat`**: Complete Docker Desktop reinstallation
  - Uninstalls Docker Desktop
  - Removes all Docker data and settings
  - Prepares system for fresh installation
  - Use this as a last resort when other methods fail

### 3. Application Deployment

- **`deploy-kubernetes-apps.bat`**: Deploys your application to Kubernetes
  - Removes existing deployments and services
  - Applies service configurations first, then deployments
  - Verifies deployment status and checks for port conflicts
  - Use after Docker Desktop is working properly

- **`verify-microservices-health.bat`**: Comprehensive health check
  - Verifies status of all Kubernetes resources
  - Tests connectivity to each service
  - Checks logs for issues
  - Tests NodePort access

## Troubleshooting Steps

Follow these steps in order to fix your Docker Desktop and Kubernetes issues:

1. **Check for port conflicts**:
   - Run `check-port-conflicts.bat`
   - Note any processes using the critical Docker/Kubernetes ports (especially 2375, 2376, 6443, and your service ports)
   - Kill conflicting processes if found using `taskkill /F /PID [process_id]`

2. **Try basic Docker Desktop fix**:
   - Run `fix-docker-desktop.bat`
   - Restart your computer when prompted
   - Try starting Docker Desktop normally

3. **Optimize Docker Desktop settings**:
   - Run `optimize-docker-settings.bat` to configure Docker Desktop properly
   - This will automatically set appropriate CPU, memory, and swap settings
   - Restart Docker Desktop after optimization

4. **If basic fix doesn't work**:
   - Run `restart-docker-kubernetes.bat`
   - Check if Docker Desktop starts properly with Kubernetes

5. **If problems persist**:
   - Run `collect-docker-logs.bat` to gather diagnostic information
   - Examine the logs for specific issues, focusing on exit codes and error messages
   - Run `reinstall-docker-desktop.bat` to completely reinstall Docker Desktop
   - Follow the provided instructions to download and install the latest version

6. **Once Docker Desktop is working**:
   - Run `deploy-kubernetes-apps.bat` to deploy your applications
   - Run `verify-microservices-health.bat` to check service health
   - Use your testing scripts to verify functionality

## Docker Desktop Settings for Kubernetes

For optimal performance with your microservices application, configure Docker Desktop as follows:

1. Open Docker Desktop settings
2. Go to "Kubernetes" and check "Enable Kubernetes"
3. Under "Resources":
   - Allocate at least 4 CPUs
   - Allocate at least 8GB of memory
   - Set swap to at least 1GB

## Common Issues and Solutions

### Exit Status 1 Error

This often indicates:
- Port conflicts with another application
- Corrupted Docker Desktop configuration
- WSL2 issues

Solution: Follow the steps above, focusing on port conflict resolution and complete reinstallation if necessary.

### Microsoft Store Issues

If Docker was installed from Microsoft Store and is having problems:
1. Uninstall using `reinstall-docker-desktop.bat`
2. Download the standard Docker Desktop installer from the official website
3. Install with administrator privileges

### Port Conflicts

The scripts created help identify and resolve port conflicts, especially:
- Frontend service using port 3001 (targetPort 3000, nodePort 30080)
- Help service using port 3002 (nodePort 30081)
- User service using port 3003 (nodePort 30082)

## Additional Resources

- [Docker Desktop for Windows Troubleshooting](https://docs.docker.com/desktop/troubleshoot/overview/)
- [Kubernetes Troubleshooting](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/)
- [Docker Desktop WSL 2 Backend](https://docs.docker.com/desktop/windows/wsl/)
