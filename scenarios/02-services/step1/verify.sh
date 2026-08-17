#!/bin/bash
set -e

if ! kubectl get svc backend-svc &>/dev/null; then
  echo "Service 'backend-svc' not found."
  exit 1
fi

TYPE=$(kubectl get svc backend-svc -o jsonpath='{.spec.type}')
SELECTOR=$(kubectl get svc backend-svc -o jsonpath='{.spec.selector.app}')
PORT=$(kubectl get svc backend-svc -o jsonpath='{.spec.ports[0].port}')

if [ "$SELECTOR" != "backend" ]; then
  echo "Service selector doesn't target app=backend (found: '$SELECTOR')."
  exit 1
fi

if [ "$PORT" != "80" ]; then
  echo "Service isn't forwarding port 80 (found: '$PORT')."
  exit 1
fi

echo "backend-svc correctly selects app=backend on port 80 (type: $TYPE)."
exit 0
