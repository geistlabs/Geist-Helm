apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.router.service.name   }}
  namespace: {{ .Values.namespace   }}
  labels:
    app: {{ .Values.router.name   }}
spec:
  clusterIP: None
  selector:
    app: {{ .Values.router.name   }}
  ports:
    - port: {{ .Values.router.service.port   }}
      name: http
