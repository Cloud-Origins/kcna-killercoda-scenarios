#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-image.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')

if ! echo "$ANSWER" | grep -q "nginx"; then
  echo "Answer file contains '$ANSWER', expected an image reference containing 'nginx'."
  exit 1
fi

if ! echo "$ANSWER" | grep -q "1.27"; then
  echo "Answer file contains '$ANSWER', expected the image tag '1.27'."
  exit 1
fi

echo "Correctly identified the container's image at the runtime layer."
exit 0
