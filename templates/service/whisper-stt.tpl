apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.whisperStt.service.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.whisperStt.name }}
spec:
  selector:
    app: {{ .Values.whisperStt.name }}
  ports:
    - port: {{ .Values.whisperStt.service.port }}
      name: http
