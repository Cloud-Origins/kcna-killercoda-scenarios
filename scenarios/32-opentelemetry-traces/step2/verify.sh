#!/bin/bash
set -e

QUERIED_FILE="/root/kcna-scratch/queried-trace.json"
if [ ! -f "$QUERIED_FILE" ]; then
  echo "No saved query result at $QUERIED_FILE."
  exit 1
fi

if ! grep -q '"operationName":"process-request"' "$QUERIED_FILE"; then
  echo "Queried trace does not contain the span 'process-request'."
  exit 1
fi

if ! grep -q '"serviceName":"kcna-demo-service"' "$QUERIED_FILE"; then
  echo "Queried trace does not show the service name 'kcna-demo-service'."
  exit 1
fi

echo "Confirmed: the trace sent via OTLP was stored and is queryable back out of Jaeger, intact."
exit 0
