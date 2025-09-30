apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.inference.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.inference.name }}
spec:
  selector:
    app: {{ .Values.inference.name }}
  ports:
    - port: {{ .Values.inference.service.port }}
      name: http
