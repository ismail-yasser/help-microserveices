@echo off
REM Script to set up Google Kubernetes Engine (GKE) free tier cluster
REM and create service account for GitHub Actions

echo GKE Setup Script
echo =================
echo.

where gcloud >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: Google Cloud SDK (gcloud) is not installed.
    echo Please install it from https://cloud.google.com/sdk/docs/install
    exit /b 1
)

REM Check if logged in
gcloud auth list --filter=status:ACTIVE --format="value(account)" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo You need to login to Google Cloud first
    gcloud auth login
)

REM Get or create project
set /p PROJECT_ID=Enter your Google Cloud project ID (leave empty to create new): 

if "%PROJECT_ID%"=="" (
    set /p PROJECT_NAME=Enter new project name: 
    
    REM Generate a project ID based on the name (simplified for batch file)
    set PROJECT_ID=%PROJECT_NAME:-=%
    set PROJECT_ID=%PROJECT_ID: =-%-!RANDOM!
    
    echo Creating new project: %PROJECT_NAME% (ID: %PROJECT_ID%)...
    gcloud projects create %PROJECT_ID% --name="%PROJECT_NAME%"
) else (
    REM Set the project
    gcloud config set project %PROJECT_ID%
)

REM Enable billing (this requires interactive consent)
echo You need to enable billing for your project.
echo Opening browser for billing setup...
gcloud billing projects link %PROJECT_ID%

REM Enable Kubernetes Engine API
echo Enabling Kubernetes Engine API...
gcloud services enable container.googleapis.com

REM Create GKE cluster
echo.
echo Creating GKE cluster (free tier)...
set /p CLUSTER_NAME=Enter cluster name [production-cluster]: 
if "%CLUSTER_NAME%"=="" set CLUSTER_NAME=production-cluster

set /p ZONE=Enter cluster zone [us-central1-a]: 
if "%ZONE%"=="" set ZONE=us-central1-a

echo Creating cluster %CLUSTER_NAME% in zone %ZONE%...
gcloud container clusters create %CLUSTER_NAME% ^
  --zone %ZONE% ^
  --num-nodes=2 ^
  --machine-type=e2-small ^
  --no-enable-autoscaling ^
  --release-channel=regular

REM Create service account for GitHub Actions
echo.
echo Creating service account for GitHub Actions...
gcloud iam service-accounts create github-actions ^
  --description="GitHub Actions CI/CD service account" ^
  --display-name="github-actions"

REM Grant Kubernetes cluster admin role
gcloud projects add-iam-policy-binding %PROJECT_ID% ^
  --member="serviceAccount:github-actions@%PROJECT_ID%.iam.gserviceaccount.com" ^
  --role="roles/container.admin"

REM Grant IAM service account user role
gcloud projects add-iam-policy-binding %PROJECT_ID% ^
  --member="serviceAccount:github-actions@%PROJECT_ID%.iam.gserviceaccount.com" ^
  --role="roles/iam.serviceAccountUser"

REM Create and download a JSON key file
echo.
echo Creating service account key file...
gcloud iam service-accounts keys create gke-service-account-key.json ^
  --iam-account=github-actions@%PROJECT_ID%.iam.gserviceaccount.com

REM Get credentials for kubectl
gcloud container clusters get-credentials %CLUSTER_NAME% --zone %ZONE%

echo.
echo Setup complete! Please add the following secrets to your GitHub repository:
echo.
echo GKE_SA_KEY: (content of gke-service-account-key.json)
echo GKE_PROJECT_ID: %PROJECT_ID%
echo GKE_CLUSTER_NAME: %CLUSTER_NAME%
echo GKE_ZONE: %ZONE%
echo.
echo To manually connect to this cluster:
echo gcloud container clusters get-credentials %CLUSTER_NAME% --zone %ZONE% --project %PROJECT_ID%
