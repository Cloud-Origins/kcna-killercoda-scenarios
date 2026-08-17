#!/bin/bash
set -e

ENDPOINTS=$(kubectl get endpoints webapp-svc -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null || echo "")

if [ -z "$ENDPOINTS" ]; then
  echo "webapp-svc still has no endpoints. Check its selector against the pod's real labels."
  exit 1
fi

RESULT=$(kubectl run test-client --rm -i --image=busybox --restart=Never --command -- wget -qO- --timeout=5 webapp-svc 2>/dev/null || echo "FAILED")

if [ "$RESULT" == "FAILED" ] || [ -z "$RESULT" ]; then
  echo "webapp-svc has endpoints but a real request through it failed. Check the Service port and targetPort."
  exit 1
fi

echo "webapp-svc is routing traffic correctly."
exit 0
