# MetalLB Configuration

This folder contains MetalLB configuration files for load balancing services in bare metal Kubernetes clusters.

## Installation

Install MetalLB using Helm with Layer 2 mode:

```bash
# Add the MetalLB Helm repository
helm repo add metallb https://metallb.github.io/metallb
helm repo update

# Install MetalLB
helm install metallb metallb/metallb \
  --namespace metallb-system \
  --create-namespace \
  --version 0.13.12
```

## Configuration

After installation, you need to configure MetalLB with an IP address pool. Create the following configuration:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250  # Replace with your available IP range
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```

Apply the configuration:

```bash
kubectl apply -f metallb-config.yaml
```

## Verification

Verify MetalLB is working:

```bash
# Check MetalLB pods
kubectl get pods -n metallb-system

# Check IP address pool
kubectl get ipaddresspools -n metallb-system

# Check L2 advertisement
kubectl get l2advertisements -n metallb-system
```

## Usage

MetalLB will automatically assign external IPs to LoadBalancer services:

- **Ingress-Nginx**: Will get an external IP for HTTP/HTTPS traffic
- **Other Services**: Any service with `type: LoadBalancer` will get an IP

## Important Notes

- **IP Range**: Configure an IP range that's available on your network
- **Layer 2 Mode**: Uses ARP/NDP for IP assignment (simpler than BGP)
- **Network Requirements**: Ensure the IP range is not used by other devices
- **Firewall**: May need to allow traffic on the assigned IPs

## Troubleshooting

If services don't get external IPs:

1. Check MetalLB logs: `kubectl logs -n metallb-system -l app=metallb`
2. Verify IP pool configuration: `kubectl describe ipaddresspool -n metallb-system`
3. Check for IP conflicts in your network
4. Ensure the IP range is in the same subnet as your cluster nodes
