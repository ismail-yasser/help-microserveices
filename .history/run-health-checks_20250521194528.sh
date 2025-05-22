#!/bin/bash

# Health check test script for Kubernetes cluster

# Display usage
function show_usage() {
    echo "Usage: $0 [--local|--kubernetes]"
    echo "  --local       Test health endpoints in local environment"
    echo "  --kubernetes  Test health endpoints in Kubernetes environment"
    echo ""
}

# Parse arguments
ENVIRONMENT=""

if [ "$#" -eq 0 ]; then
    # No arguments, try to detect environment
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
