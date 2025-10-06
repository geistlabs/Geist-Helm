apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.whisper.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.whisper.name }}
spec:
  replicas: {{ .Values.whisper.replicas }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: {{ .Values.whisper.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.whisper.name }}
    spec:
      nodeSelector:
        nvidia.com/gpu: "true"
      containers:
        - name: {{ .Values.whisper.name }}
          image: "{{ .Values.whisper.image.repository }}:{{ .Values.whisper.image.tag }}"
          imagePullPolicy: {{ .Values.whisper.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.whisper.service.port }}
          env:
            - name: NODE_ENV
              value: {{ .Values.whisper.env.NODE_ENV }}
            - name: PORT
              value: {{ .Values.whisper.env.PORT | quote }}
            - name: WHISPER_BINARY_PATH
              value: {{ .Values.whisper.env.WHISPER_BINARY_PATH }}
            - name: WHISPER_MODEL_PATH
              value: {{ .Values.whisper.env.WHISPER_MODEL_PATH }}
            # GPU-specific environment variables
            - name: CUDA_VISIBLE_DEVICES
              value: "0"
            - name: NVIDIA_VISIBLE_DEVICES
              value: "all"
          # GPU resource requests and limits (1 slice = 25% of GPU)
          resources:
            requests:
              nvidia.com/gpu: 1
            limits:
              nvidia.com/gpu: 1
          volumeMounts:
            - name: whisper-models-volume
              mountPath: /models
      volumes:
        - name: whisper-models-volume
          hostPath:
            path: {{ .Values.whisper.models.hostPath }}
