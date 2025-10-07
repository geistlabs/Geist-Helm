apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.mcpFetch.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.mcpFetch.name }}
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
spec:
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  rules:
    - host: {{ .Values.ingress.mcpFetch.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.mcpFetch.service.name }}
                port:
                  number: {{ .Values.mcpFetch.service.port }}
  tls:
  - hosts:
    - {{ .Values.ingress.mcpFetch.host }}
    secretName: {{ .Values.ingress.mcpFetch.name }}-tls
