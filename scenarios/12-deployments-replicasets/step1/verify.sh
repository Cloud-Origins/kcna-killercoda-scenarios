#!/bin/bash
set -e

IMAGE=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
REPLICAS=$(kubectl get deploy web -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "")
READY=$(kubectl get deploy web -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
PORT=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null || echo "")

if [ "$IMAGE" != "nginx:1.27" ]; then
  echo "Deployment 'web' image is '$IMAGE', expected 'nginx:1.27'."
  exit 1
fi

if [ "$REPLICAS" != "3" ]; then
  echo "Deployment 'web' spec.replicas is '$REPLICAS', expected 3."
  exit 1
fi

if [ "$READY" != "3" ]; then
  echo "Deployment 'web' has $READY/3 ready replicas."
  exit 1
fi

if [ "$PORT" != "80" ]; then
  echo "Deployment 'web' does not expose containerPort 80."
  exit 1
fi

echo "Deployment 'web' correctly configured with 3 ready replicas."
exit 0
