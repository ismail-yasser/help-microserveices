# Kubernetes Microservices Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                Internet                                     │
└─────────────────────────────┬───────────────────────────────────────────────┘
                              │
┌─────────────────────────────┴───────────────────────────────────────────────┐
│                        Kubernetes Cluster                                  │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         Ingress Controller                          │    │
│  │                         (nginx-ingress)                            │    │
│  │                                                                     │    │
│  │  Routes:                                                            │    │
│  │  • frontend.local/ → Frontend Service                              │    │
│  │  • frontend.local/api/users/* → User Service                       │    │
│  │  • frontend.local/api/help/* → Help Service                        │    │
│  └─────────────────────────┬───────────────────────────────────────────┘    │
│                            │                                                │
│  ┌─────────────────────────┴───────────────────────────────────────────┐    │
│  │                      Frontend Service                              │    │
│  │                      (LoadBalancer)                                │    │
│  │                      Port: 80 → 3000                               │    │
│  └─────────────────────────┬───────────────────────────────────────────┘    │
│                            │                                                │
│  ┌─────────────────────────┴───────────────────────────────────────────┐    │
│  │                   Frontend Deployment                               │    │
│  │                                                                     │    │
│  │  ┌───────────────┐    ┌───────────────┐                            │    │
│  │  │  Frontend     │    │  Frontend     │                            │    │
│  │  │  Pod 1        │    │  Pod 2        │                            │    │
│  │  │  (React App)  │    │  (React App)  │                            │    │
│  │  │  Port: 3000   │    │  Port: 3000   │                            │    │
│  │  └───────────────┘    └───────────────┘                            │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                     User Service                                    │    │
│  │                     (ClusterIP)                                    │    │
│  │                     Port: 3000                                     │    │
│  └─────────────────────────┬───────────────────────────────────────────┘    │
│                            │                                                │
│  ┌─────────────────────────┴───────────────────────────────────────────┐    │
│  │                  User Service Deployment                            │    │
│  │                                                                     │    │
│  │  ┌───────────────┐    ┌───────────────┐                            │    │
│  │  │  User Svc     │    │  User Svc     │                            │    │
│  │  │  Pod 1        │    │  Pod 2        │                            │    │
│  │  │  (Node.js)    │    │  (Node.js)    │                            │    │
│  │  │  Port: 3000   │    │  Port: 3000   │                            │    │
│  │  └───────────────┘    └───────────────┘                            │    │
│  └─────────────────────────┬───────────────────────────────────────────┘    │
│                            │                                                │
│  ┌─────────────────────────┴───────────────────────────────────────────┐    │
│  │                     Help Service                                    │    │
│  │                     (ClusterIP)                                    │    │
│  │                     Port: 3002                                     │    │
│  └─────────────────────────┬───────────────────────────────────────────┘    │
│                            │                                                │
│  ┌─────────────────────────┴───────────────────────────────────────────┐    │
│  │                  Help Service Deployment                            │    │
│  │                                                                     │    │
│  │  ┌───────────────┐    ┌───────────────┐                            │    │
│  │  │  Help Svc     │    │  Help Svc     │                            │    │
│  │  │  Pod 1        │    │  Pod 2        │                            │    │
│  │  │  (Node.js)    │    │  (Node.js)    │                            │    │
│  │  │  Port: 3002   │    │  Port: 3002   │                            │    │
│  │  └───────────────┘    └───────────────┘                            │    │
│  └─────────────────────────┬───────────────────────────────────────────┘    │
│                            │                                                │
│  ┌─────────────────────────┴───────────────────────────────────────────┐    │
│  │                   Horizontal Pod Autoscaler                         │    │
│  │                                                                     │    │
│  │  • Frontend HPA: 2-5 pods, 70% CPU target                          │    │
│  │  • User Service HPA: 2-5 pods, 70% CPU target                      │    │
│  │  • Help Service HPA: 2-5 pods, 70% CPU target                      │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      ConfigMaps & Secrets                           │    │
│  │                                                                     │    │
│  │  • user-service-config: Environment variables                       │    │
│  │  • help-service-config: Environment variables                       │    │
│  │  • frontend-config: Environment variables                           │    │
│  │  • user-service-secret: MongoDB URI, JWT Secret                     │    │
│  │  • help-service-secret: MongoDB URI, JWT Secret                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           External Services                                 │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      MongoDB Atlas                                  │    │
│  │                      (Cloud Database)                              │    │
│  │                                                                     │    │
│  │  • User Collection                                                  │    │
│  │  • Help Collection                                                  │    │
│  │  • Connection via MONGO_URI secret                                  │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Component Details

### Frontend (React Application)
- **Technology**: React.js with Material-UI
- **Port**: 3000
- **Replicas**: 2 (Auto-scaling 2-5 based on CPU)
- **Service Type**: LoadBalancer
- **Health Check**: HTTP GET /

### User Service (Node.js API)
- **Technology**: Node.js with Express and MongoDB
- **Port**: 3000
- **Replicas**: 2 (Auto-scaling 2-5 based on CPU)
- **Service Type**: ClusterIP
- **Health Check**: HTTP GET /health
- **Endpoints**: 
  - `/health` - Health check
  - `/api/users/*` - User management APIs

### Help Service (Node.js API)
- **Technology**: Node.js with Express and MongoDB
- **Port**: 3002
- **Replicas**: 2 (Auto-scaling 2-5 based on CPU)
- **Service Type**: ClusterIP
- **Health Check**: HTTP GET /health
- **Endpoints**:
  - `/health` - Health check
  - `/api/help/*` - Help management APIs

### Ingress Controller
- **Technology**: nginx-ingress
- **Routes**:
  - `frontend.local/` → Frontend Service
  - `frontend.local/api/users/*` → User Service (with path rewrite)
  - `frontend.local/api/help/*` → Help Service (with path rewrite)

### Auto-scaling (HPA)
- **Metrics Server**: Enabled for CPU metrics collection
- **Target CPU**: 70% utilization
- **Min Replicas**: 2
- **Max Replicas**: 5

### Persistent Storage
- **Database**: MongoDB Atlas (Cloud)
- **Connection**: Secured via Kubernetes secrets
- **Collections**: Users, Help items

## Access Methods

### Local Development (Minikube)
1. **NodePort Access**: `http://localhost:32000`
2. **Ingress Access**: `http://frontend.local` (requires hosts entry)
3. **API Access**: 
   - `http://frontend.local/api/users/health`
   - `http://frontend.local/api/help/health`

### Production (GKE)
1. **LoadBalancer**: External IP assigned by GCP
2. **Ingress**: Domain name with SSL termination
3. **Auto-scaling**: Based on traffic and resource usage

## CI/CD Pipeline

### GitHub Actions Workflow
1. **Build Stage**: Docker image build and push to DockerHub
2. **Test Stage**: Kubernetes manifest validation
3. **Deploy Stage**: 
   - Minikube (development/testing)
   - GKE (production)
4. **Verification**: Health checks and integration tests

### Required Secrets
- `DOCKER_USERNAME`: DockerHub username
- `DOCKER_PASSWORD`: DockerHub password/token
- `MONGO_URI`: MongoDB connection string
- `JWT_SECRET`: JWT signing secret

## Monitoring and Observability

### Metrics Collection
- **Metrics Server**: CPU and memory metrics
- **HPA**: Automatic scaling based on metrics
- **Health Checks**: Readiness and liveness probes

### Logging
- **Pod Logs**: Available via `kubectl logs`
- **Service Mesh**: Future consideration for distributed tracing

## Security

### Network Policies
- Services isolated via ClusterIP
- External access only through ingress controller

### Secrets Management
- MongoDB credentials stored in Kubernetes secrets
- JWT secrets secured and mounted as environment variables

### Authentication
- JWT-based authentication between services
- Secure MongoDB connection with credentials
