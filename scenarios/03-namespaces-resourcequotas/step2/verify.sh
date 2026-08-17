#!/bin/bash
set -e

PODS=$(kubectl get pods -n team-a --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')

if [ "$PODS" != "2" ]; then
  echo "Expected exactly 2 pods in team-a (quota limit), found $PODS."
  exit 1
fi

if ! kubectl get pod pod-c -n team-a &>/dev/null; then
  echo "pod-c is not running in team-a."
  exit 1
fi

if kubectl get pod pod-b -n team-a &>/dev/null; then
  echo "pod-b still exists -- you need to free the quota by deleting it, not just adding pod-c."
  exit 1
fi

echo "Correct -- pod-a and pod-c running, within the 2-pod quota."
exit 0
