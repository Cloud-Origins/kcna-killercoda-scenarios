#!/bin/bash
set -e

STATUS=$(helm status webapp -o json 2>/dev/null | grep -o '"status":"[a-z]*"' | head -1 | cut -d'"' -f4 || echo "")
if [ "$STATUS" != "deployed" ]; then
  echo "Helm release 'webapp' status is '$STATUS', expected 'deployed'."
  exit 1
fi

DEPLOY=$(kubectl get deploy -l app.kubernetes.io/instance=webapp -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
if [ -z "$DEPLOY" ]; then
  echo "No Deployment found with label app.kubernetes.io/instance=webapp."
  exit 1
fi

READY=$(kubectl get deploy "$DEPLOY" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "2" ]; then
  echo "Deployment '$DEPLOY' has $READY/2 ready replicas -- did you set replicaCount: 2?"
  exit 1
fi

IMAGE=$(kubectl get deploy "$DEPLOY" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
if [[ "$IMAGE" != nginx:1.27* ]]; then
  echo "Deployment '$DEPLOY' image is '$IMAGE', expected it to start with 'nginx:1.27'."
  exit 1
fi

echo "Chart scaffolded, parameterized, and installed correctly."
exit 0
