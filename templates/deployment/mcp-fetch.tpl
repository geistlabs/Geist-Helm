apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.mcpFetch.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.mcpFetch.name }}
spec:
  replicas: {{ .Values.mcpFetch.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.mcpFetch.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.mcpFetch.name }}
    spec:
      nodeSelector:
        splitgpu: "true"
      containers:
        - name: {{ .Values.mcpFetch.name }}
          image: "{{ .Values.mcpFetch.image.repository }}:{{ .Values.mcpFetch.image.tag }}"
          imagePullPolicy: {{ .Values.mcpFetch.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.mcpFetch.service.port }}
          command: ["sh", "-c", "pip install mcp-http-bridge && mcp-http-bridge --command 'python -m mcp_server_fetch' --port {{ .Values.mcpFetch.service.port }} --host 0.0.0.0"]
          env:
            - name: PORT
              value: "{{ .Values.mcpFetch.service.port }}"
