apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.webapp.name }} 
  namespace: {{ .Values.namespace }} 
  labels:
    app: {{ .Values.webapp.name }} 
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
spec:
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  rules:
    - host: {{ .Values.ingress.webapp.host }} 
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.webapp.service.name }} 
                port:
                  number: {{ .Values.webapp.service.port }}
  tls:
  - hosts:
    - {{ .Values.ingress.webapp.host }}
    secretName: {{ .Values.ingress.webapp.name }}-tls 
