#!/bin/bash
set -e

STATUS=$(kubectl get pipelinerun ci-run-1 -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}' 2>/dev/null || echo "")

if [ "$STATUS" != "True" ]; then
  echo "PipelineRun 'ci-run-1' Succeeded status is '$STATUS', expected 'True'."
  exit 1
fi

echo "PipelineRun 'ci-run-1' succeeded -- build handed the artifact to verify through the shared workspace."
exit 0
