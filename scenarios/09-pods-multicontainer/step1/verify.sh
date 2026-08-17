#!/bin/bash
set -e

IMAGE=$(kubectl get pod web -o jsonpath='{.spec.containers[0].image}' 2>/dev/null || echo "")
LABEL=$(kubectl get pod web -o jsonpath='{.metadata.labels.app}' 2>/dev/null || echo "")
PORT=$(kubectl get pod web -o jsonpath='{.spec.containers[0].ports[0].containerPort}' 2>/dev/null || echo "")
PHASE=$(kubectl get pod web -o jsonpath='{.status.phase}' 2>/dev/null || echo "")

if [ "$IMAGE" != "nginx:1.27" ]; then
  echo "Pod 'web' image is '$IMAGE', expected 'nginx:1.27'."
  exit 1
fi

if [ "$LABEL" != "web" ]; then
  echo "Pod 'web' is missing label app=web."
  exit 1
fi

if [ "$PORT" != "80" ]; then
  echo "Pod 'web' does not expose containerPort 80."
  exit 1
fi

if [ "$PHASE" != "Running" ]; then
  echo "Pod 'web' is not Running (phase: $PHASE)."
  exit 1
fi

echo "Pod 'web' is correctly configured and running."
exit 0
