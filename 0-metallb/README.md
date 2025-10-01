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
  --version 0.15.2
```

## Configuration

After installation, you need to configure MetalLB with an IP address pool. The configuration is split into two files:

- [`ipaddresspool.yaml`](./ipaddresspool.yaml) - Defines the IP address pool
- [`l2advertisement.yaml`](./l2advertisement.yaml) - Defines the L2 advertisement

**Important**: Update the IP address in `ipaddresspool.yaml` to match your environment:
- For **Hetzner vSwitch with public subnet**: Use the public IP range assigned to your vSwitch
- For **single public IP**: Use your master node's public IP (e.g., `5.9.63.248/32`)
- For **private network**: Use an available private IP range (e.g., `192.168.100.100-192.168.100.110`)

Apply the configuration:

```bash
kubectl apply -f ipaddresspool.yaml
kubectl apply -f l2advertisement.yaml
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
