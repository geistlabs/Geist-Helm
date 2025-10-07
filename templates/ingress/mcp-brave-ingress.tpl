apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.mcpBrave.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.mcpBrave.name }}
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
spec:
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  rules:
    - host: {{ .Values.ingress.mcpBrave.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.mcpBrave.service.name }}
                port:
                  number: {{ .Values.mcpBrave.service.port }}
  tls:
  - hosts:
    - {{ .Values.ingress.mcpBrave.host }}
    secretName: {{ .Values.ingress.mcpBrave.name }}-tls
