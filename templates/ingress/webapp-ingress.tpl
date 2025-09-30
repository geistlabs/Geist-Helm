apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.webapp.name }} 
  namespace: {{ .Values.namespace }} 
  labels:
    app: {{ .Values.webapp.name }} 
  annotations:
    kubernetes.io/ingress.class: {{ .Values.ingress.ingressClassName }} 
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
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
