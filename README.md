# Geist-Helm

## Prerequisites Installation Order

**⚠️ IMPORTANT: Install these infrastructure components in the correct order before deploying the main application:**

### 1. MetalLB (First)
See [1-metallb/README.md](1-metallb/README.md) for installation instructions.

### 2. Ingress-Nginx (Second)  
See [0-ingress-nginx/README.md](0-ingress-nginx/README.md) for installation instructions.

### 3. cert-manager (Third)
See [2-cert-manager/README.md](2-cert-manager/README.md) for installation instructions.

**Why this order matters:**
- MetalLB provides load balancing infrastructure
- Ingress-Nginx needs MetalLB to assign external IPs
- cert-manager needs a working ingress controller for HTTP-01 challenges

---

## Manual

### Initial Deploy to Environments

```shell
helm install -n development -f values-development.yaml geist-development .
helm install -n production -f values-production.yaml geist-production .
```

### Upgrade Environments (after initial install)

```shell
helm upgrade -n development -f values-development.yaml geist-development .
helm upgrade -n production -f values-production.yaml geist-production .
```

## Clear Environments

```shell
helm uninstall -n development geist-development .
helm uninstall -n production geist-production .
```