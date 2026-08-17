#!/bin/bash
set -e

IMAGE=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
if [ "$IMAGE" != "nginx:1.26" ]; then
  echo "Deployment 'web' image is '$IMAGE', expected it to be rolled back to 'nginx:1.26'."
  exit 1
fi

READY=$(kubectl get deploy web -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "3" ]; then
  echo "Deployment 'web' has $READY/3 ready replicas after the rollback."
  exit 1
fi

echo "Rollback confirmed: back to nginx:1.26 with 3/3 ready."
exit 0
