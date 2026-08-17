#!/bin/bash
set -e

IMAGE=$(kubectl get deploy exam-app -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")
if [ "$IMAGE" != "nginx:1.27-alpine" ]; then
  echo "B1: exam-app image is '$IMAGE', expected 'nginx:1.27-alpine'."
  exit 1
fi

READY=$(kubectl get deploy exam-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY" != "4" ]; then
  echo "B1: exam-app has $READY/4 ready replicas after scaling."
  exit 1
fi

ANSWER_FILE="/root/kcna-scratch/answer-crash-reason.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "B2: No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
if [ "$ANSWER" != "crash-reason-connection-refused" ]; then
  echo "B2: Answer file contains '$ANSWER', expected 'crash-reason-connection-refused' from the --previous instance's logs."
  exit 1
fi

echo "Part B complete: exam-app rolled and scaled, mock-crash correctly diagnosed."
exit 0
