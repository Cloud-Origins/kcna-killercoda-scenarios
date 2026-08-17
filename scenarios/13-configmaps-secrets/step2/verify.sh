#!/bin/bash
set -e

PHASE=$(kubectl get pod configured -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$PHASE" != "Running" ]; then
  echo "Pod 'configured' is not Running (phase: $PHASE)."
  exit 1
fi

APP_MODE=$(kubectl exec configured -- printenv APP_MODE 2>/dev/null || echo "")
API_KEY=$(kubectl exec configured -- printenv API_KEY 2>/dev/null || echo "")

if [ "$APP_MODE" != "production" ]; then
  echo "APP_MODE inside the container is '$APP_MODE', expected 'production'. Check the configMapKeyRef."
  exit 1
fi

if [ "$API_KEY" != "s3cr3t" ]; then
  echo "API_KEY inside the container is '$API_KEY', expected 's3cr3t'. Check the secretKeyRef."
  exit 1
fi

echo "Both values correctly landed inside the container as env vars."
exit 0
