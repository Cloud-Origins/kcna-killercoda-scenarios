#!/bin/bash
set -e

STATUS=$(kubectl get pipelinerun ci-run-2-broken -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}' 2>/dev/null || echo "")

if [ "$STATUS" != "False" ]; then
  echo "PipelineRun 'ci-run-2-broken' Succeeded status is '$STATUS', expected 'False' -- the broken build should have failed verification."
  exit 1
fi

ORIGINAL_STATUS=$(kubectl get pipelinerun ci-run-1 -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}' 2>/dev/null || echo "")
if [ "$ORIGINAL_STATUS" != "True" ]; then
  echo "Original PipelineRun 'ci-run-1' is no longer showing Succeeded=True -- it should be untouched."
  exit 1
fi

echo "Confirmed: the broken pipeline failed as expected, and the original good pipeline is still Succeeded."
exit 0
