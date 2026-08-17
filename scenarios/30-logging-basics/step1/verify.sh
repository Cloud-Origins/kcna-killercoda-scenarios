#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-sidecar-log.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
if [ "$ANSWER" != "SIDECAR-LOG-LINE" ]; then
  echo "Answer file contains '$ANSWER', expected 'SIDECAR-LOG-LINE' -- did you use -c sidecar?"
  exit 1
fi

echo "Correctly read logs from the 'sidecar' container specifically."
exit 0
