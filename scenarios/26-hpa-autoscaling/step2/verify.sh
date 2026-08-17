#!/bin/bash
set -e

COMMAND=$(kubectl get deploy cpu-app -o jsonpath='{.spec.template.spec.containers[0].command[2]}' 2>/dev/null || echo "")
if [[ "$COMMAND" != *"while true; do :; done"* ]]; then
  echo "Deployment 'cpu-app' does not have the busy-loop command yet."
  exit 1
fi

CURRENT_REPLICAS=$(kubectl get hpa cpu-app -o jsonpath='{.status.currentReplicas}' 2>/dev/null || echo "1")

if [ "$CURRENT_REPLICAS" -le 1 ]; then
  echo "HPA 'cpu-app' currentReplicas is $CURRENT_REPLICAS -- it hasn't scaled out yet. Give metrics-server and the HPA controller another minute."
  exit 1
fi

echo "Confirmed: HPA scaled cpu-app out to $CURRENT_REPLICAS replicas under real CPU load."
exit 0
