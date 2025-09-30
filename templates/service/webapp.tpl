apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.webapp.service.name   }}
  namespace: {{ .Values.namespace   }}
  labels:
    app: {{ .Values.webapp.name   }}
spec:
  selector:
    app: {{ .Values.webapp.name   }}
  ports:
    - port: {{ .Values.webapp.service.port   }}
      name: http
