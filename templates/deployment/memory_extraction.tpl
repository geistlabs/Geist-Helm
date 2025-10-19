apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.memory_extraction.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.memory_extraction.name }}
spec:
  replicas: {{ .Values.memory_extraction.replicas }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: {{ .Values.memory_extraction.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.memory_extraction.name }}
    spec:
      nodeSelector:
        nvidia.com/gpu: "true"
      containers:
        - name: {{ .Values.memory_extraction.name }}
          image: "{{ .Values.memory_extraction.image.repository   }}:{{ .Values.memory_extraction.image.tag   }}"
          imagePullPolicy: {{ .Values.memory_extraction.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.memory_extraction.service.port }}
          volumeMounts:
            - name: models-volume
              mountPath: /models
      volumes:
        - name: models-volume
          hostPath:
            path: /root/models
