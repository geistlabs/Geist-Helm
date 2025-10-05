apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.inference.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.inference.name }}
spec:
  replicas: {{ .Values.inference.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.inference.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.inference.name }}
    spec:
      nodeSelector:
        nvidia.com/gpu: "true"
      containers:
        - name: {{ .Values.inference.name }}
          image: "{{ .Values.inference.image.repository   }}:{{ .Values.inference.image.tag   }}"
          imagePullPolicy: {{ .Values.inference.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.inference.service.port }}
          env:
            - name: NODE_ENV
              value: {{ .Values.inference.env.NODE_ENV }}
            - name: PORT
              value: {{ .Values.inference.env.PORT | quote }}
            - name: API_URL
              value: {{ .Values.inference.env.API_URL }}
            - name: INFERENCE_URL
              value: {{ .Values.inference.env.INFERENCE_URL }}
            - name: EMBEDDINGS_URL
              value: {{ .Values.inference.env.EMBEDDINGS_URL }}
            # GPU-specific environment variables
            - name: CUDA_VISIBLE_DEVICES
              value: "0"
            - name: NVIDIA_VISIBLE_DEVICES
              value: "all"
            - name: GPU_LAYERS
              value: "8"
          # GPU resource requests and limits (3 slices = 75% of GPU)
          resources:
            requests:
              nvidia.com/gpu: 3
            limits:
              nvidia.com/gpu: 3
          volumeMounts:
            - name: models-volume
              mountPath: /models
      volumes:
        - name: models-volume
          hostPath:
            path: /root/models
