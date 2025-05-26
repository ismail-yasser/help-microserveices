@echo off
REM Helm Chart Validation and Installation Guide
REM This script provides instructions for installing Helm and using the chart

echo ================================================
echo User Service Helm Chart - Setup Guide
echo ================================================
echo.

echo Step 1: Install Helm (if not already installed)
echo -----------------------------------------------
echo Visit: https://helm.sh/docs/intro/install/
echo.
echo For Windows (using Chocolatey):
echo   choco install kubernetes-helm
echo.
echo For Windows (using Scoop):
echo   scoop install helm
echo.
echo For Windows (manual):
echo   Download from: https://github.com/helm/helm/releases
echo   Extract and add to PATH
echo.

echo Step 2: Verify Installation
echo ---------------------------
echo Run: helm version
echo.

echo Step 3: Validate the Chart
echo --------------------------
echo Run: helm lint ./helm-charts/user-service
echo.

echo Step 4: Test Template Generation
echo --------------------------------
echo helm template user-service ./helm-charts/user-service \
echo   --set secret.MONGO_URI="test-uri" \
echo   --set secret.JWT_SECRET="test-secret"
echo.

echo Step 5: Install the Chart
echo -------------------------
echo Development:
echo   helm install user-service-dev ./helm-charts/user-service \
echo     -f ./helm-charts/user-service/values-development.yaml \
echo     --set secret.MONGO_URI="your-mongo-uri" \
echo     --set secret.JWT_SECRET="your-jwt-secret" \
echo     --namespace development \
echo     --create-namespace
echo.
echo Production:
echo   helm install user-service-prod ./helm-charts/user-service \
echo     -f ./helm-charts/user-service/values-production.yaml \
echo     --set secret.MONGO_URI="your-mongo-uri" \
echo     --set secret.JWT_SECRET="your-jwt-secret" \
echo     --namespace production \
echo     --create-namespace
echo.

echo Step 6: Verify Deployment
echo -------------------------
echo kubectl get pods -n development -l app.kubernetes.io/name=user-service
echo kubectl get svc -n development user-service-dev
echo helm status user-service-dev -n development
echo.

echo Step 7: Test the Service
echo ------------------------
echo kubectl port-forward -n development svc/user-service-dev 3000:3000
echo curl http://localhost:3000/health
echo.

echo ================================================
echo Chart Files Created:
echo ================================================
dir /b templates\*
echo.
echo Additional files:
echo - Chart.yaml (chart metadata)
echo - values.yaml (default configuration)
echo - values-development.yaml (dev configuration)
echo - values-production.yaml (prod configuration)
echo - README.md (detailed documentation)
echo - install-helm-chart.bat (installation script)
echo - upgrade-helm-chart.bat (upgrade script)
echo - uninstall-helm-chart.bat (uninstall script)
echo.

echo ================================================
echo Next Steps:
echo ================================================
echo 1. Install Helm if not already installed
echo 2. Run 'helm lint ./helm-charts/user-service' to validate
echo 3. Use the installation scripts or manual commands above
echo 4. Configure your MongoDB URI and JWT secret
echo 5. Deploy to your Kubernetes cluster
echo.

pause
