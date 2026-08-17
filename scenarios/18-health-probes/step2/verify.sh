#!/bin/bash
set -e

TARGET_FILE="/root/kcna-scratch/target-pod.txt"
if [ ! -f "$TARGET_FILE" ]; then
  echo "No target pod recorded at $TARGET_FILE."
  exit 1
fi

POD=$(cat "$TARGET_FILE" | tr -d '[:space:]')

PHASE=$(kubectl get pod "$POD" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
RESTARTS=$(kubectl get pod "$POD" -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null || echo "")
READY=$(kubectl get pod "$POD" -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null || echo "")

if [ "$PHASE" != "Running" ]; then
  echo "Pod '$POD' is not Running (phase: $PHASE) -- liveness should never have fired."
  exit 1
fi

if [ "$RESTARTS" != "0" ]; then
  echo "Pod '$POD' has $RESTARTS restarts -- liveness fired, but it shouldn't have (TCP probe doesn't check content)."
  exit 1
fi

if [ "$READY" != "false" ]; then
  echo "Pod '$POD' containerStatuses.ready is '$READY', expected 'false' -- readiness should be failing."
  exit 1
fi

ENDPOINT_IPS=$(kubectl get endpoints web-svc -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null || echo "")
POD_IP=$(kubectl get pod "$POD" -o jsonpath='{.status.podIP}' 2>/dev/null || echo "")

if echo "$ENDPOINT_IPS" | grep -q "$POD_IP"; then
  echo "Pod '$POD' IP is still in web-svc endpoints -- it should have been removed once readiness failed."
  exit 1
fi

echo "Confirmed: pod stayed Running (0 restarts) but was correctly pulled from Service endpoints."
exit 0
