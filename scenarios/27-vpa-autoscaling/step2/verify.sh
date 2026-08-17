#!/bin/bash
set -e

CURRENT_REQUEST=$(kubectl get pods -l app=sized-app -o jsonpath='{.items[0].spec.containers[0].resources.requests.cpu}' 2>/dev/null || echo "")

if [ -z "$CURRENT_REQUEST" ]; then
  echo "Could not read the current CPU request from the sized-app pod."
  exit 1
fi

if [ "$CURRENT_REQUEST" == "10m" ]; then
  echo "Pod's CPU request is still the original '10m' -- VPA's updater hasn't evicted and resized it yet. Give it another minute."
  exit 1
fi

echo "Confirmed: VPA resized the pod's CPU request to $CURRENT_REQUEST (from the original 10m)."
exit 0
