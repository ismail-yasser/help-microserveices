#!/bin/bash
# Script to apply GKE-specific resources

# Display usage information
display_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Apply GKE-specific resources to the cluster"
    echo
    echo "Options:"
    echo "  --project-id ID      Google Cloud Project ID"
    echo "  --cluster NAME       GKE Cluster name"
    echo "  --zone ZONE          GKE Cluster zone"
    echo "  -h, --help           Display this help message"
    echo
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project-id)
            PROJECT_ID="$2"
            shift 2
            ;;
        --cluster)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        --zone)
            ZONE="$2"
            shift 2
            ;;
        -h|--help)
            display_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            display_usage
            exit 1
            ;;
    esac
done

# Check if required parameters are provided
if [ -z "$PROJECT_ID" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$ZONE" ]; then
    echo "Error: Missing required parameters."
    display_usage
    exit 1
fi

# Set GKE context
echo "Setting GKE context..."
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

# Apply GKE-specific configurations
echo "Applying GKE-specific configurations..."

# Create namespace if it doesn't exist
kubectl get namespace production > /dev/null 2>&1 || kubectl create namespace production

# Set context to production namespace
kubectl config set-context --current --namespace=production

# Apply GKE-specific services
echo "Applying GKE LoadBalancer services..."
kubectl apply -f k8s/gke/frontend-service.yaml

# Apply regular k8s resources but with production namespace
echo "Applying regular Kubernetes resources to production namespace..."
kubectl apply -f k8s/help-service-secret.yaml -n production
kubectl apply -f k8s/user-service-secret.yaml -n production
kubectl apply -f k8s/help-service-configmap.yaml -n production
kubectl apply -f k8s/user-service-configmap.yaml -n production
kubectl apply -f k8s/frontend-configmap.yaml -n production

# Apply deployments with namespace
sed 's|frontend:local|'$DOCKER_USERNAME'/frontend:latest|g' k8s/frontend-deployment.yaml | kubectl apply -f - -n production
sed 's|user-service:local|'$DOCKER_USERNAME'/user-service:latest|g' k8s/user-service-deployment.yaml | kubectl apply -f - -n production
sed 's|help-service:local|'$DOCKER_USERNAME'/help-service:latest|g' k8s/help-service-deployment.yaml | kubectl apply -f - -n production

# Apply other services
kubectl apply -f k8s/help-service-service.yaml -n production
kubectl apply -f k8s/user-service-service.yaml -n production

echo
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/frontend-deployment -n production --timeout=180s
kubectl rollout status deployment/user-service-deployment -n production --timeout=180s
kubectl rollout status deployment/help-service-deployment -n production --timeout=180s

echo
echo "Deployments complete! Getting service endpoints..."
kubectl get services -n production

# Get the external IP for frontend service
FRONTEND_IP=$(kubectl get svc frontend -n production -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo
echo "Your application is available at: http://$FRONTEND_IP"
