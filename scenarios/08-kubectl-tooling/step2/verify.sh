#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-fieldtype.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
REAL=$(kubectl explain pod.spec.terminationGracePeriodSeconds 2>/dev/null | grep -i '^TYPE:' | awk '{print $2}' | tr '[:upper:]' '[:lower:]')

if [ "$ANSWER" != "$REAL" ]; then
  echo "Answer '$ANSWER' does not match the real TYPE reported by kubectl explain ('$REAL')."
  exit 1
fi

echo "Correct field type from kubectl explain."
exit 0
