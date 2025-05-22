#!/bin/bash

# Consolidated health check test script for Kubernetes cluster

# Display usage
function show_usage() {
    echo "Usage: $0 [--local|--kubernetes] [--direct]"
    echo "  --local       Test health endpoints in local environment"
    echo "  --kubernetes  Test health endpoints in Kubernetes environment"
    echo "  --direct      Test directly using curl instead of using Node.js script"
    echo ""
}

# Parse arguments
ENVIRONMENT=""
USE_DIRECT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)
      ENVIRONMENT="local"
      shift
      ;;
    --kubernetes)
      ENVIRONMENT="kubernetes"
      shift
      ;;
    --direct)
      USE_DIRECT=true
      shift
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_usage
      exit 1
      ;;
  esac
done

# Auto-detect environment if not specified
if [ -z "$ENVIRONMENT" ]; then
    if command -v kubectl &> /dev/null && kubectl get nodes &> /dev/null; then
        ENVIRONMENT="kubernetes"
    else
        ENVIRONMENT="local"
    fi
else
    case "$1" in
        --local)
            ENVIRONMENT="local"
            ;;
        --kubernetes)
            ENVIRONMENT="kubernetes"
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
fi

echo "Running health checks in $ENVIRONMENT environment..."

# Run the JavaScript test script with the appropriate environment variable
if [ "$ENVIRONMENT" == "kubernetes" ]; then
    KUBERNETES_ENV=true node test-health-endpoints.js
else
    node test-health-endpoints.js
fi
