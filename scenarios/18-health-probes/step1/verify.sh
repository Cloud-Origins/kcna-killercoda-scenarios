#!/bin/bash
set -e

READY=$(kubectl get deploy web -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "2" ]; then
  echo "Deployment 'web' has $READY/2 ready replicas."
  exit 1
fi

LIVENESS_PORT=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.tcpSocket.port}' 2>/dev/null || echo "")
if [ "$LIVENESS_PORT" != "80" ]; then
  echo "Container is missing a TCP livenessProbe on port 80."
  exit 1
fi

READINESS_PATH=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null || echo "")
if [ "$READINESS_PATH" != "/" ]; then
  echo "Container is missing an HTTP readinessProbe on path /."
  exit 1
fi

ENDPOINT_COUNT=$(kubectl get endpoints web-svc -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')
if [ "$ENDPOINT_COUNT" != "2" ]; then
  echo "Service 'web-svc' has $ENDPOINT_COUNT ready endpoints, expected 2."
  exit 1
fi

echo "Deployment 'web' correctly probed, both pods ready and in the Service."
exit 0
