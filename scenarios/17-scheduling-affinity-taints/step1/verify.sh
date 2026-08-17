#!/bin/bash
set -e

PHASE=$(kubectl get pod blocked-test -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$PHASE" != "Pending" ]; then
  echo "Pod 'blocked-test' phase is '$PHASE', expected 'Pending' (it should be blocked by the taint)."
  exit 1
fi

ANSWER_FILE="/root/kcna-scratch/answer-taintkey.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
if [ "$ANSWER" != "dedicated" ]; then
  echo "Answer file contains '$ANSWER', expected the taint key 'dedicated'."
  exit 1
fi

echo "Correctly diagnosed: Pod is Pending due to the 'dedicated' taint."
exit 0
