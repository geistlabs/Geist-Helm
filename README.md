# Geist-Helm

A Helm chart for deploying Geist AI backend services to Kubernetes.

## Overview

This Helm chart deploys three main services for the Geist AI platform:

- **API Service** (`api.geist.im`) - Main API service
- **Inference Service** (`inference.geist.im`) - AI inference service  
- **Embeddings Service** (`embeddings.geist.im`) - Text embeddings service

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- NGINX Ingress Controller

## Installation

### Development Environment

```bash
# Add the chart repository (if using a chart repository)
helm repo add geist-helm ./geist-helm

# Install the chart
helm install geist-ai geist-helm -f values-development.yaml
```

### Production Environment

```bash
# Install the chart
helm install geist-ai geist-helm -f values-production.yaml
```

## Configuration

The chart supports two main configuration files:

- `values-development.yaml` - Development environment settings
- `values-production.yaml` - Production environment settings

### Key Configuration Options

#### Service Configuration
- `replicas` - Number of pod replicas
- `image.repository` - Container image repository
- `image.tag` - Container image tag
- `resources` - CPU and memory limits/requests

#### Ingress Configuration
- `ingress.ingressClassName` - Ingress class name (default: nginx)
- `ingress.api.host` - API service hostname
- `ingress.inference.host` - Inference service hostname  
- `ingress.embeddings.host` - Embeddings service hostname

## Services

### API Service
- **Port**: 8000
- **Host**: api.geist.im
- **Purpose**: Main API endpoints for the Geist AI platform

### Inference Service  
- **Port**: 8001
- **Host**: inference.geist.im
- **Purpose**: AI model inference and prediction services

### Embeddings Service
- **Port**: 8002  
- **Host**: embeddings.geist.im
- **Purpose**: Text embedding generation and processing

## Resource Requirements

### Development
- **API**: 500m CPU, 1Gi memory (requests), 1000m CPU, 2Gi memory (limits)
- **Inference**: 1000m CPU, 2Gi memory (requests), 2000m CPU, 4Gi memory (limits)
- **Embeddings**: 750m CPU, 1.5Gi memory (requests), 1500m CPU, 3Gi memory (limits)

### Production
- **API**: 1000m CPU, 2Gi memory (requests), 2000m CPU, 4Gi memory (limits)
- **Inference**: 2000m CPU, 4Gi memory (requests), 4000m CPU, 8Gi memory (limits)
- **Embeddings**: 1500m CPU, 3Gi memory (requests), 3000m CPU, 6Gi memory (limits)

## Monitoring

To check the status of your deployment:

```bash
# Check deployments
kubectl get deployments --namespace <namespace>

# Check services  
kubectl get services --namespace <namespace>

# Check ingress
kubectl get ingress --namespace <namespace>

# View logs
kubectl logs -f deployment/geist-api --namespace <namespace>
kubectl logs -f deployment/geist-inference --namespace <namespace>
kubectl logs -f deployment/geist-embeddings --namespace <namespace>
```

## Uninstalling

To uninstall the chart:

```bash
helm uninstall geist-ai
```

## Contributing

1. Make changes to the chart templates or values
2. Test the changes with `helm template`
3. Update the chart version in `Chart.yaml`
4. Submit a pull request

## License

This project is licensed under the MIT License.
