#!/bin/bash
set -e

PHASE=$(kubectl get pod sidecar-demo -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$PHASE" != "Running" ]; then
  echo "Pod 'sidecar-demo' is not Running (phase: $PHASE)."
  exit 1
fi

CONTAINERS=$(kubectl get pod sidecar-demo -o jsonpath='{.spec.containers[*].name}' 2>/dev/null || echo "")
if [ "$CONTAINERS" != "app logger" ]; then
  echo "Pod 'sidecar-demo' must have exactly containers 'app' and 'logger' in that order, got: '$CONTAINERS'."
  exit 1
fi

kubectl exec sidecar-demo -c app -- sh -c "echo verify-proof-$$ > /var/log/shared/verify-check.txt" 2>/dev/null

SEEN=$(kubectl exec sidecar-demo -c logger -- cat /var/log/shared/verify-check.txt 2>/dev/null || echo "")

if [ -z "$SEEN" ]; then
  echo "Container 'logger' cannot read the file written by 'app'. Is the emptyDir volume mounted at /var/log/shared in both containers?"
  exit 1
fi

echo "Sidecar pattern confirmed: both containers share the volume."
exit 0
