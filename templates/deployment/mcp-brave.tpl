apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.mcpBrave.name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Values.mcpBrave.name }}
spec:
  replicas: {{ .Values.mcpBrave.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.mcpBrave.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.mcpBrave.name }}
    spec:
      containers:
        - name: {{ .Values.mcpBrave.name }}
          image: "{{ .Values.mcpBrave.image.repository }}:{{ .Values.mcpBrave.image.tag }}"
          imagePullPolicy: {{ .Values.mcpBrave.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.mcpBrave.service.port }}
          env:
            - name: BRAVE_MCP_TRANSPORT
              value: {{ .Values.mcpBrave.env.BRAVE_MCP_TRANSPORT }}
            - name: BRAVE_API_KEY
              valueFrom:
                secretKeyRef:
                  name: brave-api-key
                  key: api-key
