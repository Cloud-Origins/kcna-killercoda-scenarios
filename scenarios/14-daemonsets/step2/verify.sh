#!/bin/bash
set -e

TOTAL_NODES=$(kubectl get nodes --no-headers | wc -l | tr -d ' ')
DESIRED=$(kubectl get ds node-logger -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || echo "0")
READY=$(kubectl get ds node-logger -o jsonpath='{.status.numberReady}' 2>/dev/null || echo "0")

if [ "$DESIRED" != "$TOTAL_NODES" ]; then
  echo "DaemonSet 'node-logger' desired ($DESIRED) does not cover all $TOTAL_NODES nodes. Check the toleration."
  exit 1
fi

if [ "$READY" != "$TOTAL_NODES" ]; then
  echo "DaemonSet 'node-logger' ready ($READY) does not match total node count ($TOTAL_NODES)."
  exit 1
fi

echo "DaemonSet 'node-logger' now covers all $TOTAL_NODES nodes, including any tainted ones."
exit 0
