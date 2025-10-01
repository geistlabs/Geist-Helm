apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.embeddings.name }}
  namespace: {{ .Values.namespace }}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 20m
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS"
    nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "180"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "180"
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
spec:
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  rules:
    - host: {{ .Values.ingress.embeddings.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.embeddings.service.name }}
                port:
                  number: {{ .Values.embeddings.service.port }}
  tls:
  - hosts:
    - {{ .Values.ingress.embeddings.host }}
    secretName: {{ .Values.ingress.embeddings.name }}-tls
