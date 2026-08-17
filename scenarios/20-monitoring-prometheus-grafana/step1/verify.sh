#!/bin/bash
set -e

READY=$(kubectl -n monitoring get pods -l app.kubernetes.io/name=prometheus,app.kubernetes.io/component=server -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null || echo "")

if [ "$READY" != "true" ]; then
  echo "Prometheus server pod is not ready in the 'monitoring' namespace."
  exit 1
fi

echo "Prometheus server is running and ready."
exit 0
