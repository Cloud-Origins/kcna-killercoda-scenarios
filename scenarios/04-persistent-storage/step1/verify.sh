#!/bin/bash
set -e

STATUS=$(kubectl get pvc data-pvc -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$STATUS" != "Bound" ]; then
  echo "data-pvc is not Bound yet (status: '$STATUS')."
  exit 1
fi

CONTENT=$(kubectl exec writer-pod -- cat /data/proof.txt 2>/dev/null || echo "")
if [ "$CONTENT" != "kcna-persist-test" ]; then
  echo "Expected /data/proof.txt to contain 'kcna-persist-test', got: '$CONTENT'"
  exit 1
fi

echo "data-pvc bound, proof.txt written."
exit 0
