# User Service

A microservice for user management operations.

## Overview

The User Service provides RESTful APIs for managing user data including user creation, retrieval, updating, and deletion. It's designed to run in a Kubernetes environment and integrates with the frontend application.

## Features

- User CRUD operations
- RESTful API endpoints
- Health check endpoint
- Kubernetes-ready configuration
- Docker containerization

## API Endpoints

### Health Check
- **GET** `/health` - Returns service health status

### User Management
- **GET** `/api/users` - Get all users
- **POST** `/api/users` - Create a new user
- **GET** `/api/users/{id}` - Get user by ID
- **PUT** `/api/users/{id}` - Update user
- **DELETE** `/api/users/{id}` - Delete user

## Configuration

The service runs on port 3000 by default and can be configured using environment variables:

- `PORT` - Service port (default: 3000)
- `NODE_ENV` - Environment (development/production)

## Health Probes

The service includes:
- **Liveness Probe**: `/health` endpoint checked every 30 seconds
- **Readiness Probe**: `/health` endpoint checked every 10 seconds

## Docker

Build the Docker image:
```bash
docker build -t user-service .
```

Run the container:
```bash
docker run -p 3000:3000 user-service
```

## Kubernetes Deployment

The service can be deployed to Kubernetes using the provided manifests in `/k8s/user-service/`:

- `user-service-deployment.yaml` - Deployment configuration
- `user-service-service.yaml` - Service configuration
- `user-service-config.yaml` - ConfigMap
- `user-service-hpa.yaml` - Horizontal Pod Autoscaler

Deploy using:
```bash
kubectl apply -f k8s/user-service/
```

## API Documentation

Detailed API documentation is available in `api-docs.yaml` (OpenAPI 3.0 format).

## Development

1. Install dependencies: `npm install`
2. Start development server: `npm start`
3. Run tests: `npm test`

## Environment Variables

| Variable | Description  | Default     |
| -------- | ------------ | ----------- |
| PORT     | Service port | 3000        |
| NODE_ENV | Environment  | development |

## Status

- ✅ Service running
- ✅ Health checks configured
- ✅ Kubernetes ready
- ✅ API documented
