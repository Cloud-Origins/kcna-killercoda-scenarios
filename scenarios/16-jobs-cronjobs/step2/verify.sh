#!/bin/bash
set -e

SCHEDULE=$(kubectl get cronjob hello -o jsonpath='{.spec.schedule}' 2>/dev/null || echo "")
if [ -z "$SCHEDULE" ]; then
  echo "CronJob 'hello' does not exist."
  exit 1
fi

JOB=$(kubectl get jobs --no-headers -o custom-columns=NAME:.metadata.name 2>/dev/null | grep '^hello-' | head -1 || echo "")

if [ -z "$JOB" ]; then
  echo "No Job spawned from CronJob 'hello' yet. Wait for the next minute to tick over."
  exit 1
fi

LOGS=$(kubectl logs "job/$JOB" 2>/dev/null || echo "")
if ! echo "$LOGS" | grep -q "hello"; then
  echo "Job '$JOB' logs do not contain 'hello'."
  exit 1
fi

echo "CronJob 'hello' fired and produced the expected output."
exit 0
