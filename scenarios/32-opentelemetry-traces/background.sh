#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

# Jaeger all-in-one has a native OTLP receiver built in since 1.35 --
# no separate otel-collector needed for a single-node demo like this.
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jaeger
  template:
    metadata:
      labels:
        app: jaeger
    spec:
      containers:
        - name: jaeger
          image: jaegertracing/all-in-one:latest
          env:
            - name: COLLECTOR_OTLP_ENABLED
              value: "true"
          ports:
            - containerPort: 4318
            - containerPort: 16686
---
apiVersion: v1
kind: Service
metadata:
  name: jaeger
spec:
  selector:
    app: jaeger
  ports:
    - name: otlp-http
      port: 4318
      targetPort: 4318
    - name: query
      port: 16686
      targetPort: 16686
EOF

kubectl wait --for=condition=Available deployment/jaeger --timeout=120s
