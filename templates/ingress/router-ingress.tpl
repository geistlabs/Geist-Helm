apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.router.name }}
  namespace: {{ .Values.namespace }}
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS"
    nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization"
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
spec:
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  rules:
    - host: {{ .Values.ingress.router.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.router.service.name }}
                port:
                  number: {{ .Values.router.service.port }}
  tls:
  - hosts:
    - {{ .Values.ingress.router.host }}
    secretName: {{ .Values.ingress.router.name }}-tls
