apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.whisper.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.whisper.name }}
spec:
  selector:
    app: {{ .Values.whisper.name }}
  ports:
    - port: {{ .Values.whisper.service.port }}
      name: http
