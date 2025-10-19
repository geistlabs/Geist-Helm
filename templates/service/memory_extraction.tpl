apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.memory_extraction.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.memory_extraction.name }}
spec:
  selector:
    app: {{ .Values.memory_extraction.name }}
  ports:
    - port: {{ .Values.memory_extraction.service.port }}
      name: http
