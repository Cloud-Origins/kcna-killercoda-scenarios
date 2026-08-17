#!/bin/bash
set -e

POD_COUNT=$(kubectl get pods -l serving.knative.dev/service=hello --no-headers 2>/dev/null | grep -v Terminating | wc -l | tr -d ' ')

if [ "$POD_COUNT" != "0" ]; then
  echo "Still $POD_COUNT pod(s) running for the 'hello' service -- wait for the idle window to elapse (no requests, ~20-30s)."
  exit 1
fi

echo "Confirmed: 0 pods running for 'hello'. Scaled all the way to zero."
exit 0
