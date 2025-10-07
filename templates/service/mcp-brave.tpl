apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.mcpBrave.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.mcpBrave.name }}
spec:
  selector:
    app: {{ .Values.mcpBrave.name }}
  ports:
    - port: {{ .Values.mcpBrave.service.port }}
      name: http
