#!/bin/bash
set -e

PHASE=$(kubectl get pod data-0 -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$PHASE" != "Running" ]; then
  echo "Pod 'data-0' is not Running (phase: $PHASE)."
  exit 1
fi

CONTENT=$(kubectl exec data-0 -- cat /usr/share/nginx/html/proof.txt 2>/dev/null || echo "")

if [ "$CONTENT" != "kcna-sts-proof" ]; then
  echo "Pod 'data-0' does not have the expected proof file content. Was the pod actually deleted and did it come back with the same PVC?"
  exit 1
fi

echo "Identity and storage both survived the pod delete."
exit 0
