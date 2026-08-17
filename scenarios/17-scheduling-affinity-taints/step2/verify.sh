#!/bin/bash
set -e

TAINTED_NODE=$(cat /root/kcna-scratch/tainted-node.txt 2>/dev/null || echo "")

PHASE=$(kubectl get pod pinned -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$PHASE" != "Running" ]; then
  echo "Pod 'pinned' is not Running (phase: $PHASE)."
  exit 1
fi

SCHEDULED_NODE=$(kubectl get pod pinned -o jsonpath='{.spec.nodeName}' 2>/dev/null || echo "")
if [ "$SCHEDULED_NODE" != "$TAINTED_NODE" ]; then
  echo "Pod 'pinned' is scheduled on '$SCHEDULED_NODE', expected the tainted node '$TAINTED_NODE'."
  exit 1
fi

TOLERATION_KEY=$(kubectl get pod pinned -o jsonpath='{.spec.tolerations[?(@.key=="dedicated")].key}' 2>/dev/null || echo "")
if [ "$TOLERATION_KEY" != "dedicated" ]; then
  echo "Pod 'pinned' is missing the 'dedicated' toleration."
  exit 1
fi

echo "Pod 'pinned' correctly scheduled onto the tainted node via affinity and toleration."
exit 0
