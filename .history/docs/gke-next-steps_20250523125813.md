# GKE Deployment Guide - Next Steps After Applying Credentials

This guide outlines what to do after running `setup-gke.bat` and obtaining your GKE credentials.

## Step 1: Verify Google Cloud SDK Installation

If you encountered "gcloud is not recognized" error:

1. Download and install the Google Cloud SDK from: https://cloud.google.com/sdk/docs/install
2. During installation, ensure you select options to:
   - Add gcloud to your PATH
   - Configure your shell to use gcloud
3. After installation, restart your command prompt
4. Verify installation with: `gcloud --version`

## Step 2: Make Sure You're Logged In

```cmd
gcloud auth login
```

## Step 3: Set Your Project ID

```cmd
gcloud config set project YOUR_PROJECT_ID
```
Replace `YOUR_PROJECT_ID` with the project ID you created during setup.

## Step 4: Add GitHub Secrets for CI/CD

Add these secrets to your GitHub repository:

1. Go to your GitHub repository
2. Navigate to "Settings" > "Secrets and variables" > "Actions"
3. Create these new repository secrets:
   - `GKE_SA_KEY`: The entire content of the `gke-service-account-key.json` file
   - `GKE_PROJECT_ID`: Your Google Cloud project ID
   - `GKE_CLUSTER_NAME`: Your cluster name (default: "production-cluster")
   - `GKE_ZONE`: Your cluster zone (default: "us-central1-a")
   - Make sure `DOCKER_USERNAME` and `DOCKER_PASSWORD` are also set

## Step 5: Deploy to GKE

### Option A: Using GitHub Actions (Recommended)

1. Go to your GitHub repository
2. Click on "Actions" tab
3. Find the "CI/CD Pipeline" workflow
4. Click on "Run workflow"
5. Select "production" from the environment dropdown
6. Click "Run workflow"

### Option B: Manual Deployment

```cmd
cd c:\Users\IsmailYasserIsmailAb\Desktop\project
scripts\apply-gke-resources.bat --project-id YOUR_PROJECT_ID --cluster production-cluster --zone us-central1-a
```

You'll be prompted for your Docker Hub username.

## Step 6: Verify Deployment

After deployment completes, you can verify your services are running:

```cmd
kubectl get pods -n production
kubectl get services -n production
```

Your frontend service will be accessible via the LoadBalancer external IP, which should be printed at the end of the deployment process.

## Step 7: Access Your Application

1. Find your external IP:
```cmd
kubectl get services frontend -n production
```

2. Access your application in a browser at: `http://<EXTERNAL-IP>`

## Troubleshooting Common Issues

### Issue: "gcloud not recognized"
- Make sure Google Cloud SDK is installed and in your PATH
- Try restarting your command prompt after installation

### Issue: "Unable to connect to the server"
- Run: `gcloud container clusters get-credentials production-cluster --zone us-central1-a --project YOUR_PROJECT_ID`
- Check if your GKE cluster is running in Google Cloud Console

### Issue: "Image pull errors" in pod status
- Make sure your Docker Hub credentials are correct
- Verify the images are accessible in your Docker Hub account
- Check image names and tags

### Issue: "Deployment timeout"
- Check pod status with: `kubectl get pods -n production`
- View pod logs with: `kubectl logs -n production <pod-name>`

## Next Steps

- Set up DNS for your application
- Configure SSL certificates
- Implement CI/CD pipeline for automatic deployments
- Set up monitoring and alerts

For further assistance, refer to the main GKE deployment guide in the docs folder.
