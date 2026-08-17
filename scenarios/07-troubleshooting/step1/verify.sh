#!/bin/bash
set -e

READY=$(kubectl get deployment webapp -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

if [ "$READY" != "1" ]; then
  echo "webapp deployment has $READY/1 ready replicas. Check 'kubectl describe pod -l app=webapp' for the image pull error."
  exit 1
fi

echo "webapp is running."
exit 0
