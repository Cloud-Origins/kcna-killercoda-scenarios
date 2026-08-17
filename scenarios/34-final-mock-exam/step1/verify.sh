#!/bin/bash
set -e

ENDPOINT_COUNT=$(kubectl get endpoints mock-svc -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')
if [ "$ENDPOINT_COUNT" -lt 1 ]; then
  echo "A1: Service 'mock-svc' still has no endpoints. Fix its selector to match mock-backend's real labels."
  exit 1
fi

READY=$(kubectl get deploy exam-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "2" ]; then
  echo "A2: Deployment 'exam-app' has $READY/2 ready replicas."
  exit 1
fi

ENV_VALUE=$(kubectl exec deploy/exam-app -- printenv APP_MODE 2>/dev/null || echo "")
if [ "$ENV_VALUE" != "production" ]; then
  echo "A2: APP_MODE inside exam-app is '$ENV_VALUE', expected 'production' sourced from exam-config."
  exit 1
fi

READINESS_PATH=$(kubectl get deploy exam-app -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null || echo "")
if [ "$READINESS_PATH" != "/" ]; then
  echo "A2: exam-app is missing an HTTP readinessProbe on path /."
  exit 1
fi

echo "Part A complete: mock-svc fixed, exam-app built with ConfigMap env var and readiness probe."
exit 0
