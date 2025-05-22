# Kubernetes Services and Service Discovery

## Overview

This document explains how Kubernetes Services are implemented and validated in our microservices architecture.

## Service Architecture

In Kubernetes, Services provide a way to expose applications running on pods. Our application uses the following services:

1. **user-service** (ClusterIP)
   - Internal endpoint: `user-service:3000`
   - Provides user authentication and profile management

2. **help-service** (ClusterIP)
   - Internal endpoint: `help-service:3002`
   - Manages help requests and offers

3. **frontend-service** (ClusterIP/NodePort)
   - Internal endpoint: `frontend-service:80`
   - Serves the React frontend application

## What is ClusterIP?

ClusterIP is a service type that:

- Makes the service accessible only within the Kubernetes cluster
- Creates a stable DNS name for the service
- Provides load balancing across all pods matching the service selector
- Does NOT expose the service to external network traffic

## Service Configuration

Each service in `service.yaml` includes:

1. **Metadata**:
   - `name`: The hostname for the service within the cluster
   - `labels`: For organization and selection
   - `annotations`: Additional descriptive information

2. **Specification**:
   - `type: ClusterIP`: Makes the service internal to the cluster
   - `selector`: Defines which pods receive traffic (e.g., `app: user-service`)
   - `ports`: Maps external ports to container ports

## How Service Discovery Works

1. When a pod needs to communicate with another service, it can use the service's DNS name.
2. Kubernetes DNS automatically resolves service names to cluster IPs.
3. For example, `http://user-service:3000/api/health` can be used by any pod to access the user service.

## Validating Services

To validate that services are working properly:

1. **Create a test pod**:
   ```bash
   kubectl apply -f test-pod.yaml
   ```

2. **Test DNS resolution**:
   ```bash
   kubectl exec -it service-test-pod -- nslookup user-service
   kubectl exec -it service-test-pod -- nslookup help-service
   ```

3. **Test HTTP connectivity**:
   ```bash
   kubectl exec -it service-test-pod -- curl -s http://user-service:3000/api/health
   kubectl exec -it service-test-pod -- curl -s http://help-service:3002/api/health
   ```

4. **Automated validation**:
   ```bash
   # Windows:
   validate-services.bat
   
   # Linux/macOS:
   ./validate-services.sh
   ```

## Troubleshooting

If service connections fail:

1. **Verify service exists**:
   ```bash
   kubectl get services
   ```

2. **Check endpoints**:
   ```bash
   kubectl get endpoints user-service
   kubectl get endpoints help-service
   ```

3. **Verify pod selector matches**:
   ```bash
   kubectl get pods --selector=app=user-service
   kubectl get pods --selector=app=help-service
   ```

4. **Check pod status**:
   ```bash
   kubectl describe pods -l app=user-service
   kubectl describe pods -l app=help-service
   ```

5. **Network policy**:
   Check if any network policies might be blocking traffic.

## Inter-Service Communication

Services communicate with each other using their DNS names:

- From `help-service` to `user-service`: `http://user-service:3000/...`
- From frontend to backend services:
  - `http://user-service:3000/...`
  - `http://help-service:3002/...`
