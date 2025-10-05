apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.whisper.ingress.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.whisper.name }}
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
    - hosts:
        - {{ .Values.whisper.ingress.host }}
      secretName: {{ .Values.whisper.ingress.secretName }}
  rules:
    - host: {{ .Values.whisper.ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.whisper.service.name }}
                port:
                  number: {{ .Values.whisper.service.port }}
