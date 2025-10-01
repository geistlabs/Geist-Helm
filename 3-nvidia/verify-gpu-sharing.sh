#!/bin/bash

echo "=== Checking GPU Resources ==="
kubectl describe nodes | grep -A 5 "nvidia.com/gpu"

echo -e "\n=== Checking Pod Status ==="
kubectl get pods -o wide | grep gpu-pod

echo -e "\n=== Checking GPU Device Plugin Status ==="
kubectl get pods -n gpu-operator | grep device-plugin

echo -e "\n=== Checking Node GPU Capacity ==="
kubectl get nodes -o json | jq '.items[].status.capacity | select(."nvidia.com/gpu")'

echo -e "\n=== Checking Pod Events ==="
kubectl get events --field-selector involvedObject.name=gpu-pod-1
kubectl get events --field-selector involvedObject.name=gpu-pod-2
