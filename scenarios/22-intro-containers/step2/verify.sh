#!/bin/bash
set -e

CONTENT=$(kubectl exec runtime-demo -- cat /tmp/proof.txt 2>/dev/null || echo "")

if [ "$CONTENT" != "crictl-was-here" ]; then
  echo "File /tmp/proof.txt not found or wrong content via kubectl exec. Did you write it with crictl exec on the correct node?"
  exit 1
fi

echo "Confirmed: crictl exec and kubectl exec reach the exact same container."
exit 0
