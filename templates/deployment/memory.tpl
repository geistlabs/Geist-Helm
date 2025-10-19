apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.memory.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.memory.name }}
spec:
  replicas: {{ .Values.memory.replicas }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: {{ .Values.memory.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.memory.name }}
    spec:
      nodeSelector:
        nvidia.com/gpu: "true"
      containers:
        - name: {{ .Values.memory.name }}
          image: "{{ .Values.memory.image.repository   }}:{{ .Values.memory.image.tag   }}"
          imagePullPolicy: {{ .Values.memory.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.memory.service.port }}
          volumeMounts:
            - name: models-volume
              mountPath: /models
      volumes:
        - name: models-volume
          hostPath:
            path: /root/models
