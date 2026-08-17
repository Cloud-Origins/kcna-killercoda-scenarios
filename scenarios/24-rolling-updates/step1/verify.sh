#!/bin/bash
set -e

READY=$(kubectl get deploy web -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "4" ]; then
  echo "Deployment 'web' has $READY/4 ready replicas."
  exit 1
fi

IMAGE=$(kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
if [ "$IMAGE" != "nginx:1.26" ]; then
  echo "Deployment 'web' image is '$IMAGE', expected 'nginx:1.26'."
  exit 1
fi

MAX_UNAVAILABLE=$(kubectl get deploy web -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null || echo "")
if [ "$MAX_UNAVAILABLE" != "0" ]; then
  echo "Deployment 'web' strategy.rollingUpdate.maxUnavailable is '$MAX_UNAVAILABLE', expected 0."
  exit 1
fi

ENDPOINT_COUNT=$(kubectl get endpoints web-svc -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')
if [ "$ENDPOINT_COUNT" != "4" ]; then
  echo "Service 'web-svc' has $ENDPOINT_COUNT ready endpoints, expected 4."
  exit 1
fi

echo "Deployment 'web' correctly configured for a zero-downtime rollout."
exit 0
