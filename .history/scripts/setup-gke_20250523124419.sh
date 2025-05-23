#!/bin/bash
# Script to set up Google Kubernetes Engine (GKE) free tier cluster
# and create service account for GitHub Actions

echo "GKE Setup Script"
echo "================="
echo

if ! command -v gcloud &> /dev/null; then
    echo "Error: Google Cloud SDK (gcloud) is not installed."
    echo "Please install it from https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if logged in
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo "You need to login to Google Cloud first"
    gcloud auth login
fi

# Get or create project
echo "Enter your Google Cloud project ID (leave empty to create new):"
read PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo "Enter new project name:"
    read PROJECT_NAME
    PROJECT_ID=$(echo $PROJECT_NAME | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    PROJECT_ID="${PROJECT_ID}-$(date +%s | cut -c 6-10)"
    
    echo "Creating new project: $PROJECT_NAME (ID: $PROJECT_ID)..."
    gcloud projects create $PROJECT_ID --name="$PROJECT_NAME"
else
    # Set the project
    gcloud config set project $PROJECT_ID
fi

# Enable billing (this requires interactive consent)
echo "You need to enable billing for your project."
echo "Opening browser for billing setup..."
gcloud billing projects link $PROJECT_ID

# Enable Kubernetes Engine API
echo "Enabling Kubernetes Engine API..."
gcloud services enable container.googleapis.com

# Create GKE cluster
echo
echo "Creating GKE cluster (free tier)..."
echo "Enter cluster name [production-cluster]:"
read CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-production-cluster}

echo "Enter cluster zone [us-central1-a]:"
read ZONE
ZONE=${ZONE:-us-central1-a}

echo "Creating cluster $CLUSTER_NAME in zone $ZONE..."
gcloud container clusters create $CLUSTER_NAME \
  --zone $ZONE \
  --num-nodes=2 \
  --machine-type=e2-small \
  --no-enable-autoscaling \
  --release-channel=regular

# Create service account for GitHub Actions
echo
echo "Creating service account for GitHub Actions..."
gcloud iam service-accounts create github-actions \
  --description="GitHub Actions CI/CD service account" \
  --display-name="github-actions"

# Grant Kubernetes cluster admin role
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin"

# Grant IAM service account user role
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Create and download a JSON key file
echo
echo "Creating service account key file..."
gcloud iam service-accounts keys create gke-service-account-key.json \
  --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com

# Get credentials for kubectl
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE

echo
echo "Setup complete! Please add the following secrets to your GitHub repository:"
echo
echo "GKE_SA_KEY: (content of gke-service-account-key.json)"
echo "GKE_PROJECT_ID: $PROJECT_ID"
echo "GKE_CLUSTER_NAME: $CLUSTER_NAME"
echo "GKE_ZONE: $ZONE"
echo
echo "To manually connect to this cluster:"
echo "gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID"
