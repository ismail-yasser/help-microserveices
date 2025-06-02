@echo off
echo ==========================================
echo 💾 CONFIGURATION BACKUP
echo ==========================================
echo.

REM Create backup directory with timestamp
set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP_DIR=backup_%TIMESTAMP%

echo Creating backup directory: %BACKUP_DIR%
mkdir "%BACKUP_DIR%" >nul 2>&1

echo.
echo 📋 Backing up Kubernetes resources...
echo ==========================================

echo 1. Backing up deployments...
kubectl get deployments -o yaml > "%BACKUP_DIR%\deployments.yaml"
if %errorlevel% equ 0 echo ✅ Deployments backed up

echo 2. Backing up services...
kubectl get services -o yaml > "%BACKUP_DIR%\services.yaml"
if %errorlevel% equ 0 echo ✅ Services backed up

echo 3. Backing up ConfigMaps...
kubectl get configmaps -o yaml > "%BACKUP_DIR%\configmaps.yaml"
if %errorlevel% equ 0 echo ✅ ConfigMaps backed up

echo 4. Backing up Secrets...
kubectl get secrets -o yaml > "%BACKUP_DIR%\secrets.yaml"
if %errorlevel% equ 0 echo ✅ Secrets backed up

echo 5. Backing up HPA configurations...
kubectl get hpa -o yaml > "%BACKUP_DIR%\hpa.yaml" 2>nul
if %errorlevel% equ 0 echo ✅ HPA configurations backed up

echo 6. Backing up Ingress configurations...
kubectl get ingress -o yaml > "%BACKUP_DIR%\ingress.yaml" 2>nul
if %errorlevel% equ 0 echo ✅ Ingress configurations backed up

echo 7. Backing up PersistentVolumes...
kubectl get pv,pvc -o yaml > "%BACKUP_DIR%\volumes.yaml" 2>nul
if %errorlevel% equ 0 echo ✅ Volume configurations backed up

echo.
echo 📋 Backing up Helm releases...
echo ==========================================
helm list -o yaml > "%BACKUP_DIR%\helm-releases.yaml" 2>nul
if %errorlevel% equ 0 echo ✅ Helm releases backed up

echo.
echo 📋 Backing up configuration files...
echo ==========================================

REM Copy Kubernetes manifests
if exist "%~dp0..\k8s\" (
    echo Copying Kubernetes manifests...
    xcopy /E /I /H "%~dp0..\k8s" "%BACKUP_DIR%\k8s" >nul
    echo ✅ Kubernetes manifests backed up
)

REM Copy Helm charts
if exist "%~dp0..\helm-charts\" (
    echo Copying Helm charts...
    xcopy /E /I /H "%~dp0..\helm-charts" "%BACKUP_DIR%\helm-charts" >nul
    echo ✅ Helm charts backed up
)

REM Copy important configuration files
if exist "%~dp0..\docker-compose.yml" (
    copy "%~dp0..\docker-compose.yml" "%BACKUP_DIR%\" >nul
    echo ✅ Docker Compose file backed up
)

if exist "%~dp0..\metrics-server.yaml" (
    copy "%~dp0..\metrics-server.yaml" "%BACKUP_DIR%\" >nul
    echo ✅ Metrics server config backed up
)

REM Copy documentation
if exist "%~dp0..\docs\" (
    echo Copying documentation...
    xcopy /E /I /H "%~dp0..\docs" "%BACKUP_DIR%\docs" >nul
    echo ✅ Documentation backed up
)

echo.
echo 📋 Creating cluster information snapshot...
echo ==========================================
kubectl cluster-info > "%BACKUP_DIR%\cluster-info.txt"
kubectl version > "%BACKUP_DIR%\kubectl-version.txt"
kubectl config view > "%BACKUP_DIR%\kubeconfig.yaml"
kubectl get nodes -o wide > "%BACKUP_DIR%\nodes.txt"
kubectl get all > "%BACKUP_DIR%\all-resources.txt"

echo ✅ Cluster information saved

echo.
echo 📋 Creating restore instructions...
echo ==========================================

echo # Configuration Restore Instructions > "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo. >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ## Backup created on: %date% %time% >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo. >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ## To restore Kubernetes resources: >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ```bash >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f deployments.yaml >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f services.yaml >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f configmaps.yaml >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f secrets.yaml >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f hpa.yaml >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f ingress.yaml >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ``` >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo. >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ## To restore using manifests: >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ```bash >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo kubectl apply -f k8s/ >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ``` >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo. >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ## To restore Helm charts: >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ```bash >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo helm install user-service helm-charts/user-service/ >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo helm install help-service helm-charts/help-service/ >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo helm install frontend helm-charts/frontend/ >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"
echo ``` >> "%BACKUP_DIR%\RESTORE_INSTRUCTIONS.md"

echo ✅ Restore instructions created

echo.
echo 📊 Backup Summary:
echo ==========================================
echo Backup location: %CD%\%BACKUP_DIR%
echo.
echo Files created:
dir "%BACKUP_DIR%" /B

echo.
echo ✅ BACKUP COMPLETED SUCCESSFULLY!
echo ==========================================
echo.
echo Backup location: %CD%\%BACKUP_DIR%
echo.
echo The backup includes:
echo - All Kubernetes resources (YAML format)
echo - Kubernetes manifest files
echo - Helm charts and releases
echo - Cluster information
echo - Restore instructions
echo.
echo To restore from backup:
echo   1. Review RESTORE_INSTRUCTIONS.md
echo   2. Apply the YAML files to your cluster
echo   3. Or use the original manifest/Helm files
