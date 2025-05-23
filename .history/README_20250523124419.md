# Microservices Kubernetes Deployment

This project contains configuration for deploying a microservices application to Kubernetes, with support for both local development (Minikube) and production (Google Kubernetes Engine).

## Architecture

The application consists of three main services:
- Frontend: A web interface for users
- User Service: Handles user authentication and management
- Help Service: Provides support and documentation

## Local Development with Minikube

### Prerequisites
- Minikube
- kubectl
- Docker
- WSL (for Windows users, optional)

### Setup

1. Start Minikube:
```bash
minikube start
```

2. Load Docker images to Minikube:
```bash
# Windows
.\scripts\load-images-to-minikube.bat

# Linux/Mac
./scripts/load-images-to-minikube.sh
```

3. Deploy all resources:
```bash
# Windows
.\scripts\apply-all-resources.bat

# Linux/Mac
./scripts/apply-all-resources.sh
```

4. Validate the deployment:
```bash
kubectl get pods
kubectl get services
```

5. Access the application:
```bash
minikube service frontend --url
```

### WSL Integration (Windows Only)

If you're using WSL on Windows, you can access your Minikube cluster from WSL:

```bash
mkdir -p ~/.kube && cp /mnt/c/Users/YourUsername/.kube/config ~/.kube/config
```

## Production Deployment with Google Kubernetes Engine (GKE)

### Setting up GKE

1. Install Google Cloud SDK (gcloud):
   - Download from https://cloud.google.com/sdk/docs/install

2. Run the GKE setup script:
```bash
# Windows
.\scripts\setup-gke.bat

# Linux/Mac
./scripts/setup-gke.sh
```

3. Follow the script prompts to:
   - Log in to Google Cloud
   - Create or select a project
   - Enable billing
   - Create a GKE cluster
   - Create a service account for GitHub Actions
   - Generate credentials

### Configuring GitHub Actions for GKE

1. Add these secrets to your GitHub repository:
   - `GKE_SA_KEY`: Contents of the `gke-service-account-key.json` file
   - `GKE_PROJECT_ID`: Your Google Cloud project ID
   - `GKE_CLUSTER_NAME`: Your cluster name (e.g., "production-cluster")
   - `GKE_ZONE`: Your cluster zone (e.g., "us-central1-a")
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password

2. Trigger the workflow:
   - Go to GitHub Actions
   - Select the "CI/CD Pipeline" workflow
   - Click "Run workflow"
   - Select "production" environment
   - Click "Run workflow"

### Manual Deployment to GKE

You can also deploy manually to GKE:

```bash
# Windows
.\scripts\apply-gke-resources.bat --project-id YOUR_PROJECT_ID --cluster YOUR_CLUSTER --zone YOUR_ZONE

# Linux/Mac
./scripts/apply-gke-resources.sh --project-id YOUR_PROJECT_ID --cluster YOUR_CLUSTER --zone YOUR_ZONE
```

## Multi-Environment Strategy

This project supports two environments:

1. **Test Environment (K3d)**
   - Uses lightweight K3d cluster in CI pipeline
   - Automatically deployed on push to main branch
   - Used for integration tests

2. **Production Environment (GKE)**
   - Uses GKE free tier for production workloads
   - Manually triggered deployment
   - Separated into its own namespace

## Troubleshooting

### Local Minikube Issues

- **Connection refused**: Make sure Minikube is running with `minikube status`
- **Image pull failures**: Check if images are loaded with `minikube image ls | grep local`
- **Config issues**: Verify your kubeconfig with `kubectl config view --minify`

### GKE Issues

- **Connection issues**: Verify credentials with `gcloud container clusters get-credentials YOUR_CLUSTER --zone YOUR_ZONE`
- **Permissions**: Check service account permissions in Google Cloud Console
- **Resource quotas**: Monitor quotas in Google Cloud Console > IAM & Admin > Quotas

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Contributing

Please read the [contributing guidelines](CONTRIBUTING.md) before submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
