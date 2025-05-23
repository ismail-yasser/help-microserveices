# Google Kubernetes Engine (GKE) Deployment Guide

This guide explains how to deploy our microservices application to Google Kubernetes Engine (GKE) using the Free Tier.

## Prerequisites

- Google Cloud account
- Google Cloud SDK (gcloud) installed
- kubectl installed
- Docker installed
- Access to GitHub repository with appropriate permissions to add secrets

## Setting Up GKE Free Tier

### Option 1: Using the Setup Script

We've provided setup scripts to make the GKE configuration process easier:

#### For Linux/Mac Users:
```bash
# Make the script executable
chmod +x ./scripts/setup-gke.sh

# Run the script
./scripts/setup-gke.sh
```

#### For Windows Users:
```
.\scripts\setup-gke.bat
```

The script will:
1. Log you into Google Cloud (if not already logged in)
2. Create or select a Google Cloud project
3. Enable billing for the project
4. Enable the Kubernetes Engine API
5. Create a GKE cluster using free tier settings
6. Create a service account for GitHub Actions
7. Generate the necessary credentials
8. Guide you through setting up GitHub repository secrets

### Option 2: Manual Setup

If you prefer to set up manually, follow these steps:

1. **Create a Google Cloud Project**:
   ```bash
   gcloud projects create YOUR_PROJECT_ID --name="YOUR_PROJECT_NAME"
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Enable Billing**: 
   Visit the Google Cloud Console and enable billing for your project.

3. **Enable Kubernetes Engine API**:
   ```bash
   gcloud services enable container.googleapis.com
   ```

4. **Create a GKE Cluster**:
   ```bash
   gcloud container clusters create production-cluster \
     --zone us-central1-a \
     --num-nodes=2 \
     --machine-type=e2-small \
     --no-enable-autoscaling \
     --release-channel=regular
   ```

5. **Create Service Account for GitHub Actions**:
   ```bash
   gcloud iam service-accounts create github-actions \
     --description="GitHub Actions CI/CD service account" \
     --display-name="github-actions"
   
   # Grant Kubernetes cluster admin role
   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/container.admin"
   
   # Grant IAM service account user role
   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/iam.serviceAccountUser"
   
   # Create and download a JSON key file
   gcloud iam service-accounts keys create gke-service-account-key.json \
     --iam-account=github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com
   ```

## Setting Up GitHub Actions for GKE Deployment

1. **Add GitHub Secrets**:
   - Go to your GitHub repository
   - Navigate to Settings > Secrets and variables > Actions
   - Add the following secrets:
     - `GKE_SA_KEY`: Content of your `gke-service-account-key.json` file
     - `GKE_PROJECT_ID`: Your Google Cloud project ID
     - `GKE_CLUSTER_NAME`: Your cluster name (e.g., "production-cluster")
     - `GKE_ZONE`: Your cluster zone (e.g., "us-central1-a")

2. **Run the Deployment Workflow**:
   - Go to your GitHub repository
   - Navigate to Actions > CI/CD Pipeline
   - Click "Run workflow"
   - Select "production" from the environment dropdown
   - Click "Run workflow"

3. **Monitor the Deployment**:
   - Watch the workflow execution in the GitHub Actions tab
   - Once completed, you can check your GKE cluster:
   ```bash
   gcloud container clusters get-credentials production-cluster --zone us-central1-a
   kubectl get pods
   kubectl get services
   ```

## Accessing Your Deployed Application

After successful deployment, you can access your application using the external IP assigned to your services:

```bash
kubectl get services
```

Look for the EXTERNAL-IP of your frontend service.

## Managing Multiple Environments

Our setup supports two environments:
- **Test**: Uses K3d for lightweight testing during CI/CD
- **Production**: Uses GKE for actual production deployment

### Test Environment
The test environment is automatically deployed on every push to the main branch. It creates a temporary K3d cluster in GitHub Actions, deploys the application, runs tests, and then tears down the cluster.

### Production Environment
Production deployment is triggered manually via the GitHub Actions workflow dispatch with "production" selected as the environment.

## Troubleshooting

### Common Issues

1. **Connection Issues**:
   ```bash
   # Verify GKE credentials
   gcloud container clusters get-credentials production-cluster --zone us-central1-a
   kubectl cluster-info
   ```

2. **Permission Issues**:
   Check if the service account has the necessary permissions.

3. **Resource Limitations**:
   Free tier has resource limitations. Monitor usage in Google Cloud Console.

### Logs and Monitoring

Access logs for deployed services:
```bash
kubectl logs -f deployment/frontend-deployment
kubectl logs -f deployment/help-service-deployment
kubectl logs -f deployment/user-service-deployment
```

## Cost Management for GKE Free Tier

To stay within the free tier limits:
- Use a single zonal cluster (not regional)
- Monitor usage in Google Cloud Console
- Delete the cluster when not in use:
  ```bash
  gcloud container clusters delete production-cluster --zone us-central1-a
  ```

## Additional Resources

- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [GKE Free Tier Information](https://cloud.google.com/kubernetes-engine/pricing)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
