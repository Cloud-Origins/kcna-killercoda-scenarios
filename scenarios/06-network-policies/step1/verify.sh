#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-bug.txt"

if [ ! -f "$ANSWER_FILE" ]; then
  echo "Answer file not found. Diagnose the policy first, then write the mismatched label value to $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')

if [ "$ANSWER" != "frontnd" ]; then
  echo "Incorrect. You answered '$ANSWER'. Compare 'kubectl get pod frontend --show-labels' against the policy's podSelector value character by character."
  exit 1
fi

echo "Correct -- the policy's podSelector says app=frontnd, but the pod is labeled app=frontend. Typo."
exit 0
