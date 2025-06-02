# Quick Reference Guide - Microservices Scripts

## 🚀 Most Common Commands

### Instant Setup (< 2 minutes)
```batch
scripts\index.bat
# Select option 1 (Quick Start) -> 1 (Ultra-fast setup)
```

### Full Development Setup (5-10 minutes)
```batch
scripts\quick-start\setup-development.bat
```

### Check Everything is Working
```batch
scripts\monitoring\check-status.bat
```

### View Application URLs
```batch
scripts\utilities\get-service-urls.bat
```

## 📁 Script Categories

| Category           | Purpose           | Key Scripts                                |
| ------------------ | ----------------- | ------------------------------------------ |
| **🚀 quick-start/** | Get running fast  | `quick-start.bat`, `setup-development.bat` |
| **🔧 deployment/**  | Build & deploy    | `deploy-project.bat`, `build-images.bat`   |
| **🎛️ management/**  | Control services  | `manage-project.bat`, `start-services.bat` |
| **📊 monitoring/**  | Status & logs     | `check-status.bat`, `view-logs.bat`        |
| **🔄 maintenance/** | Updates & cleanup | `update-images.bat`, `cleanup-project.bat` |
| **🌐 utilities/**   | Helper tools      | `get-service-urls.bat`                     |

## 🆘 Troubleshooting Shortcuts

### Project Not Working?
```batch
scripts\monitoring\troubleshoot.bat
```

### Services Not Starting?
```batch
scripts\management\restart-services.bat
```

### Can't Access Services?
```batch
# Check if running
scripts\monitoring\check-status.bat

# Get URLs
scripts\utilities\get-service-urls.bat
```

### Minikube Issues?
```batch
# Restart Minikube
minikube stop && minikube start

# Or use troubleshoot script
scripts\monitoring\troubleshoot.bat
```

## 🎯 Quick Workflows

### New Developer Setup
1. `scripts\quick-start\setup-development.bat`
2. `scripts\monitoring\check-status.bat`
3. `scripts\utilities\get-service-urls.bat`

### Daily Development
1. `scripts\monitoring\check-status.bat`
2. `scripts\monitoring\view-logs.bat` (if needed)
3. `scripts\management\restart-services.bat` (if needed)

### Production Deployment
1. `scripts\deployment\build-images.bat --version v1.x.x`
2. `scripts\deployment\deploy-production.bat`
3. `scripts\monitoring\health-checks.bat`

### Maintenance
1. `scripts\monitoring\health-checks.bat`
2. `scripts\maintenance\update-images.bat`
3. `scripts\maintenance\backup-config.bat`

## 📖 Getting Help

### For Any Script
```batch
script-name.bat --help
```

### Interactive Navigation
```batch
scripts\index.bat
```

### Comprehensive Help
```batch
scripts\quick-start\help.bat
```

---
**💡 Tip**: Use `scripts\index.bat` as your main entry point - it provides organized access to all functionality!
