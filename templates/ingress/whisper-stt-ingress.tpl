apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.whisperStt.ingress.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.whisperStt.name }}
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
    - hosts:
        - {{ .Values.whisperStt.ingress.host }}
      secretName: {{ .Values.whisperStt.ingress.secretName }}
  rules:
    - host: {{ .Values.whisperStt.ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Values.whisperStt.service.name }}
                port:
                  number: {{ .Values.whisperStt.service.port }}
