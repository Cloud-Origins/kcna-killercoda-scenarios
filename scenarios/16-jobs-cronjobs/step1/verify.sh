#!/bin/bash
set -e

SUCCEEDED=$(kubectl get job counter -o jsonpath='{.status.succeeded}' 2>/dev/null || echo "0")
if [ "$SUCCEEDED" != "1" ]; then
  echo "Job 'counter' has not completed successfully (succeeded: $SUCCEEDED)."
  exit 1
fi

LOGS=$(kubectl logs job/counter 2>/dev/null || echo "")
if ! echo "$LOGS" | grep -q "done"; then
  echo "Job 'counter' logs do not contain 'done'. Check the command."
  exit 1
fi

echo "Job 'counter' completed successfully."
exit 0
