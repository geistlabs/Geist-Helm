apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.webapp.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.webapp.name }}
spec:
  replicas: {{ .Values.webapp.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.webapp.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.webapp.name }}
    spec:
      containers:
        - name: {{ .Values.webapp.name }}
          image: "{{ .Values.webapp.image.repository   }}:{{ .Values.webapp.image.tag   }}"
          imagePullPolicy: {{ .Values.webapp.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.webapp.service.port }}
          env:
            - name: NODE_ENV
              value: {{ .Values.webapp.env.NODE_ENV }}
            - name: PORT
              value: {{ .Values.webapp.env.PORT | quote }}
            - name: API_URL
              value: {{ .Values.webapp.env.API_URL }}
            - name: INFERENCE_URL
              value: {{ .Values.webapp.env.INFERENCE_URL }}
            - name: EMBEDDINGS_URL
              value: {{ .Values.webapp.env.EMBEDDINGS_URL }}
