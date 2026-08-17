#!/bin/bash
set -e

IMAGE=$(kubectl get ds node-logger -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
LABEL=$(kubectl get ds node-logger -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null || echo "")
DESIRED=$(kubectl get ds node-logger -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || echo "0")
READY=$(kubectl get ds node-logger -o jsonpath='{.status.numberReady}' 2>/dev/null || echo "0")

if [ "$IMAGE" != "busybox:1.36" ]; then
  echo "DaemonSet 'node-logger' image is '$IMAGE', expected 'busybox:1.36'."
  exit 1
fi

if [ "$LABEL" != "node-logger" ]; then
  echo "DaemonSet 'node-logger' pod template is missing label app=node-logger."
  exit 1
fi

if [ "$DESIRED" -lt 1 ] || [ "$DESIRED" != "$READY" ]; then
  echo "DaemonSet 'node-logger' desired ($DESIRED) does not match ready ($READY)."
  exit 1
fi

echo "DaemonSet 'node-logger' correctly scheduled ($READY pods ready)."
exit 0
