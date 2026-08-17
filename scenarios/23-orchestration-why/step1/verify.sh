#!/bin/bash
set -e

REMAINING=$(kubectl get pods -l 'run in (manual-1,manual-2,manual-3)' --no-headers 2>/dev/null | wc -l | tr -d ' ')

if [ "$REMAINING" != "2" ]; then
  echo "Expected exactly 2 manual pods remaining after deleting one, found $REMAINING."
  exit 1
fi

DELETED=$(kubectl get pod manual-2 2>/dev/null || echo "NOTFOUND")
if [ "$DELETED" != "NOTFOUND" ]; then
  echo "Pod 'manual-2' still exists -- delete it to prove nothing replaces it."
  exit 1
fi

ANSWER_FILE="/root/kcna-scratch/answer-manual-count.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
if [ "$ANSWER" != "2" ]; then
  echo "Answer file says '$ANSWER', expected '2' surviving pods."
  exit 1
fi

echo "Confirmed: manual-2 is gone for good, nothing replaced it."
exit 0
