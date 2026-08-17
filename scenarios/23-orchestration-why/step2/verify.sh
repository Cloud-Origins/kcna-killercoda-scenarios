#!/bin/bash
set -e

READY=$(kubectl get deploy controlled -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

if [ "$READY" != "3" ]; then
  echo "Deployment 'controlled' has $READY/3 ready replicas -- the ReplicaSet should have replaced the deleted pod by now."
  exit 1
fi

echo "Confirmed: the controller replaced the deleted pod automatically."
exit 0
