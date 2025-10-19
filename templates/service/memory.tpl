apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.memory.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.memory.name }}
spec:
  selector:
    app: {{ .Values.memory.name }}
  ports:
    - port: {{ .Values.memory.service.port }}
      name: http
