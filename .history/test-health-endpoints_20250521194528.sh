#!/bin/bash

# Script to test health endpoints in Kubernetes cluster

echo "Testing health endpoints in Kubernetes cluster..."
echo "-------------------------------------------------"

# Test user-service health endpoint
echo "Checking user-service health:"
kubectl exec -it service-test-pod -- curl -s http://user-service:3000/api/health

echo
echo "-------------------------------------------------"

# Test help-service health endpoint
echo "Checking help-service health:"
kubectl exec -it service-test-pod -- curl -s http://help-service:3002/api/health

echo
echo "-------------------------------------------------"
echo "Health check completed!"
