# Geist-Helm

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

Helm was used to install:

- Ingress Nginx
- MetaLB
- Cert-Manager