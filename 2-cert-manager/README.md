# cert-manager Configuration

This folder contains all cert-manager related configuration files for automatic TLS certificate management.

## Files

### `letsencrypt-cluster-issuer.yaml`
Contains the ClusterIssuer resources for Let's Encrypt:
- `letsencrypt-prod` - Production certificates (rate limited)
- `letsencrypt-staging` - Staging certificates (no rate limits, for testing)

### `example-tls-ingress.yaml`
Example of how to use cert-manager with ingress resources, showing:
- cert-manager annotation configuration
- TLS section setup
- Secret name configuration

## Usage

1. **Install cert-manager**:
   ```bash
   # Add the Jetstack Helm repository
   helm repo add jetstack https://charts.jetstack.io
   helm repo update
   
   # Install cert-manager
   helm install cert-manager jetstack/cert-manager \
     --namespace cert-manager \
     --create-namespace \
     --version v1.18.2 \
     --set crds.enabled=true
   ```

2. **Apply ClusterIssuers**:
   ```bash
   kubectl apply -f letsencrypt-cluster-issuer.yaml
   ```

3. **Use in ingress resources**:
   Add these annotations and TLS section to your ingress templates:
   ```yaml
   metadata:
     annotations:
       cert-manager.io/cluster-issuer: "letsencrypt-staging"  # or "letsencrypt-prod"
   spec:
     tls:
     - hosts:
       - your-domain.com
       secretName: your-domain-tls
   ```

## Current Configuration

- **Email**: `example@example.com` (example email for testing)
- **Issuer**: `letsencrypt-staging` (configured in all ingress templates)
- **Challenge Type**: HTTP-01
- **Ingress Class**: nginx

## Notes

- All ingress templates in `templates/ingress/` are already configured with cert-manager
- Certificates will be automatically created when DNS points to your control-plane IP
- Use staging issuer for testing, production issuer for live certificates
