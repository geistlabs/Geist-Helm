apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.mcpFetch.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.mcpFetch.name }}
spec:
  selector:
    app: {{ .Values.mcpFetch.name }}
  ports:
    - port: {{ .Values.mcpFetch.service.port }}
      name: http
