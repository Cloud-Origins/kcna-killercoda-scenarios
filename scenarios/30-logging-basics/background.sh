#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-log
  labels:
    app: multi-log
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "while true; do echo APP-LOG-LINE; sleep 2; done"]
    - name: sidecar
      image: busybox:1.36
      command: ["sh", "-c", "while true; do echo SIDECAR-LOG-LINE; sleep 2; done"]
---
apiVersion: v1
kind: Pod
metadata:
  name: crasher
  labels:
    app: crasher
spec:
  volumes:
    - name: data
      emptyDir: {}
  containers:
    - name: crasher
      image: busybox:1.36
      command:
        - sh
        - -c
        - >
          if [ -f /data/marker ]; then
            echo post-crash-steady-state;
            sleep 3600;
          else
            touch /data/marker;
            echo crash-reason-db-timeout;
            exit 1;
          fi
      volumeMounts:
        - name: data
          mountPath: /data
EOF

kubectl wait --for=condition=Ready pod/multi-log --timeout=60s

# Wait for the crasher container to have actually crashed and restarted
# into its steady state before the learner's timer starts.
for i in $(seq 1 30); do
  RESTARTS=$(kubectl get pod crasher -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null || echo "0")
  READY=$(kubectl get pod crasher -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null || echo "false")
  if [ "$RESTARTS" -ge 1 ] && [ "$READY" == "true" ]; then
    break
  fi
  sleep 3
done

touch /tmp/kcna-background-done
