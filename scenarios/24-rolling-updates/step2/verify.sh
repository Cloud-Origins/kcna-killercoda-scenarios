#!/bin/bash
set -e

IMAGE=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
if [ "$IMAGE" != "nginx:1.27" ]; then
  echo "Deployment 'web' image is '$IMAGE', expected 'nginx:1.27' -- rollout not triggered yet."
  exit 1
fi

READY=$(kubectl get deploy web -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "4" ]; then
  echo "Deployment 'web' has $READY/4 ready replicas after the rollout."
  exit 1
fi

FAILS=$(kubectl exec traffic-monitor -- cat /tmp/fail-count.txt 2>/dev/null || echo "")
if [ -z "$FAILS" ]; then
  echo "Could not read /tmp/fail-count.txt from traffic-monitor -- has it finished its requests yet?"
  exit 1
fi

if [ "$FAILS" != "0" ]; then
  echo "traffic-monitor recorded $FAILS failed requests during the rollout, expected 0."
  exit 1
fi

echo "Rolled to nginx:1.27 with 0 failed requests during the entire rollout."
exit 0
