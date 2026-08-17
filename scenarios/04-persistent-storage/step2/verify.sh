#!/bin/bash
set -e

if kubectl get pod writer-pod &>/dev/null; then
  echo "writer-pod still exists -- delete it first to prove the data isn't pod-local."
  exit 1
fi

if ! kubectl get pod reader-pod &>/dev/null; then
  echo "reader-pod not found."
  exit 1
fi

CONTENT=$(kubectl exec reader-pod -- cat /data/proof.txt 2>/dev/null || echo "")
if [ "$CONTENT" != "kcna-persist-test" ]; then
  echo "Expected reader-pod to see 'kcna-persist-test' in /data/proof.txt, got: '$CONTENT'"
  exit 1
fi

echo "Correct -- data survived writer-pod's deletion because it lives on the PV, not the pod."
exit 0
