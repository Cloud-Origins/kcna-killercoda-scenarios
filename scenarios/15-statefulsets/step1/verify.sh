#!/bin/bash
set -e

CLUSTER_IP=$(kubectl get svc data -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "")
if [ "$CLUSTER_IP" != "None" ]; then
  echo "Service 'data' clusterIP is '$CLUSTER_IP', expected 'None' (headless)."
  exit 1
fi

for i in 0 1; do
  PHASE=$(kubectl get pod "data-$i" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$PHASE" != "Running" ]; then
    echo "Pod 'data-$i' is not Running (phase: $PHASE)."
    exit 1
  fi

  PVC_PHASE=$(kubectl get pvc "www-data-$i" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$PVC_PHASE" != "Bound" ]; then
    echo "PVC 'www-data-$i' is not Bound (phase: $PVC_PHASE)."
    exit 1
  fi
done

echo "Headless Service and StatefulSet correctly configured, both pods have bound PVCs."
exit 0
