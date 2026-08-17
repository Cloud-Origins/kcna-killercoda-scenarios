#!/bin/bash
set -e

CTX_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo "")

if [ "$CTX_NS" != "dev" ]; then
  echo "Current context's default namespace is not 'dev'. Run: kubectl config set-context --current --namespace=dev"
  exit 1
fi

ANSWER_FILE="/root/kcna-scratch/answer-podname.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
REAL=$(kubectl get pod dev-worker -n dev -o jsonpath='{.metadata.name}')

if [ "$ANSWER" != "$REAL" ]; then
  echo "Answer file contains '$ANSWER', expected the real pod name '$REAL'."
  exit 1
fi

echo "Default namespace set and jsonpath extraction correct."
exit 0
