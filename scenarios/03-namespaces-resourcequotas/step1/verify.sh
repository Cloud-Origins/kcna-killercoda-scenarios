#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-quota.txt"

if [ ! -f "$ANSWER_FILE" ]; then
  echo "Answer file not found. Diagnose the rejection first, then write the quota name to $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')

if [ "$ANSWER" != "team-a-quota" ]; then
  echo "Incorrect. You answered '$ANSWER'. Run 'kubectl get resourcequota -n team-a' to find the real blocker."
  exit 1
fi

echo "Correct -- team-a-quota (pods: 2) is blocking pod-c."
exit 0
