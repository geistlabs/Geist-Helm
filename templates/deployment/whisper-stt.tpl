apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.whisperStt.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.whisperStt.name }}
spec:
  replicas: {{ .Values.whisperStt.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.whisperStt.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.whisperStt.name }}
    spec:
      nodeSelector:
        nvidia.com/gpu: "true"
      containers:
        - name: {{ .Values.whisperStt.name }}
          image: "{{ .Values.whisperStt.image.repository }}:{{ .Values.whisperStt.image.tag }}"
          imagePullPolicy: {{ .Values.whisperStt.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.whisperStt.service.port }}
          env:
            - name: NODE_ENV
              value: {{ .Values.whisperStt.env.NODE_ENV }}
            - name: PORT
              value: {{ .Values.whisperStt.env.PORT | quote }}
            - name: WHISPER_BINARY_PATH
              value: {{ .Values.whisperStt.env.WHISPER_BINARY_PATH }}
            - name: WHISPER_MODEL_PATH
              value: {{ .Values.whisperStt.env.WHISPER_MODEL_PATH }}
            # GPU-specific environment variables
            - name: CUDA_VISIBLE_DEVICES
              value: "0"
            - name: NVIDIA_VISIBLE_DEVICES
              value: "all"
          # GPU resource requests and limits
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
            path: {{ .Values.whisperStt.models.hostPath }}
