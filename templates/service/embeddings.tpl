apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.embeddings.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.embeddings.name }}
spec:
  selector:
    app: {{ .Values.embeddings.name }}
  ports:
    - port: {{ .Values.embeddings.service.port }}
      name: http
