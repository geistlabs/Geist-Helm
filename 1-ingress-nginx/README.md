# Ingress-Nginx Configuration

This folder contains ingress-nginx related configuration files for HTTP and HTTPS routing.

## Installation

Install ingress-nginx using Helm:

```bash
# Add the ingress-nginx Helm repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --version 4.8.3
```

## Verification

After installation, verify that the ingress controller is running:

```bash
# Check if the ingress controller pod is running
kubectl get pods -n ingress-nginx

# Check the ingress controller service
kubectl get svc -n ingress-nginx
```

## Usage

The ingress-nginx controller will automatically handle ingress resources with the `nginx` ingress class. All ingress templates in the main `templates/ingress/` directory are configured to use this controller.

## Configuration

The ingress controller is configured with:
- **Ingress Class**: `nginx`
- **Default Backend**: Handles requests that don't match any ingress rules
- **Load Balancer**: Works with MetalLB for external access

## Notes

- The ingress controller will be exposed via a LoadBalancer service
- MetalLB will assign an external IP to the ingress controller
- All ingress resources should use `kubernetes.io/ingress.class: nginx` annotation
