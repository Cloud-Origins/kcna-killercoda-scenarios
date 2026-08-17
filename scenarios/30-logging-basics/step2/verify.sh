#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-previous-log.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE."
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
if [ "$ANSWER" != "crash-reason-db-timeout" ]; then
  echo "Answer file contains '$ANSWER', expected 'crash-reason-db-timeout' from the --previous instance's logs."
  exit 1
fi

echo "Correctly read the crashed instance's logs with --previous."
exit 0
