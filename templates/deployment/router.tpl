apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.router.name }}
  namespace: {{ .Values.namespace   }}
  labels:
    app: {{ .Values.router.name }}
spec:
  replicas: {{ .Values.router.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.router.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.router.name }}
    spec:
      containers:
        - name: {{ .Values.router.name }}
          image: "{{ .Values.router.image.repository   }}:{{ .Values.router.image.tag   }}"
          imagePullPolicy: {{ .Values.router.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.router.service.port }}
          env:
            - name: NODE_ENV
              value: {{ .Values.router.env.NODE_ENV }}
            - name: PORT
              value: {{ .Values.router.env.PORT | quote }}
            - name: API_URL
              value: {{ .Values.router.env.API_URL }}
            - name: INFERENCE_URL
              value: {{ .Values.router.env.INFERENCE_URL }}
            - name: EMBEDDINGS_URL
              value: {{ .Values.router.env.EMBEDDINGS_URL }}
            {{- if .Values.router.whisper.enabled }}
            - name: WHISPER_MODEL_PATH
              value: {{ .Values.router.whisper.modelPath }}
            - name: WHISPER_BINARY_PATH
              value: {{ .Values.router.whisper.binaryPath }}
            {{- end }}
          {{- if .Values.router.volumeMounts }}
          volumeMounts:
            {{- toYaml .Values.router.volumeMounts | nindent 12 }}
          {{- end }}
      {{- if .Values.router.volumes }}
      volumes:
        {{- toYaml .Values.router.volumes | nindent 8 }}
      {{- end }}
