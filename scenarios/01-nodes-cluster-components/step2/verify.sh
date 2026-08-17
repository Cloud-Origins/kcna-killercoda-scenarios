#!/bin/bash
set -e

LABELED_COUNT=$(kubectl get nodes -l role=worker-demo --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')

if [ "$LABELED_COUNT" != "1" ]; then
  echo "No node labeled role=worker-demo found yet."
  exit 1
fi

LABELED_NODE=$(kubectl get nodes -l role=worker-demo -o jsonpath='{.items[0].metadata.name}')
CP_NODE=$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}')

if [ "$LABELED_NODE" == "$CP_NODE" ]; then
  echo "You labeled the control plane node, not the worker. Remove the label and try the other node."
  exit 1
fi

echo "Correct -- $LABELED_NODE is labeled role=worker-demo."
exit 0
