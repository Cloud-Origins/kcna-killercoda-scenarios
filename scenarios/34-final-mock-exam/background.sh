#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mock-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mock-backend
  template:
    metadata:
      labels:
        app: mock-backend
    spec:
      containers:
        - name: mock-backend
          image: nginx:1.27
---
apiVersion: v1
kind: Service
metadata:
  name: mock-svc
spec:
  selector:
    app: mock-backend-typo
  ports:
    - port: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: mock-crash
  labels:
    app: mock-crash
spec:
  volumes:
    - name: data
      emptyDir: {}
  containers:
    - name: mock-crash
      image: busybox:1.36
      command:
        - sh
        - -c
        - >
          if [ -f /data/marker ]; then
            echo steady-state;
            sleep 3600;
          else
            touch /data/marker;
            echo crash-reason-connection-refused;
            exit 1;
          fi
      volumeMounts:
        - name: data
          mountPath: /data
EOF

kubectl wait --for=condition=Available deployment/mock-backend --timeout=90s

for i in $(seq 1 30); do
  RESTARTS=$(kubectl get pod mock-crash -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null || echo "0")
  READY=$(kubectl get pod mock-crash -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null || echo "false")
  if [ "$RESTARTS" -ge 1 ] && [ "$READY" == "true" ]; then
    break
  fi
  sleep 3
done

touch /tmp/kcna-background-done
