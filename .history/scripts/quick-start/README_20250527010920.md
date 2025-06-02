# Quick Start Scripts

🚀 **Get your microservices project running fast!**

## Scripts in this folder:

### `quick-start.bat`
- **Purpose**: Ultra-fast deployment (2 minutes)
- **Usage**: `quick-start.bat [--quick|--prod]`
- **Features**: 
  - Quick mode for instant deployment
  - Development setup option
  - Production deployment option
  - Minimal validation for speed

### `setup-development.bat`
- **Purpose**: Complete development environment setup
- **Usage**: `setup-development.bat`
- **Features**:
  - Prerequisites checking
  - Minikube setup and configuration
  - Docker environment setup
  - Build all Docker images
  - Deploy development environment
  - Install dependencies
  - Create development namespace

### `help.bat`
- **Purpose**: Interactive script index and launcher
- **Usage**: `help.bat`
- **Features**:
  - Overview of all available scripts
  - Quick launch menu
  - Script recommendations
  - Direct access to documentation

## Quick Usage Examples:

```batch
# Fastest start (2 minutes)
scripts\quick-start\quick-start.bat --quick

# Full development setup
scripts\quick-start\setup-development.bat

# Interactive help and script browser
scripts\quick-start\help.bat
```

## When to use these scripts:

- **First time users**: Start with `setup-development.bat`
- **Quick testing**: Use `quick-start.bat --quick`
- **Need help**: Run `help.bat` for guidance
- **Team onboarding**: Perfect for new developers

## Prerequisites:
- Docker Desktop
- kubectl
- Minikube (or other Kubernetes cluster)
- (Optional) Node.js for development features

---
💡 **Tip**: These scripts are designed to get you productive immediately. For ongoing management, use the scripts in the `management/` folder.
