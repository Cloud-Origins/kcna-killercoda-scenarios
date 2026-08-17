#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-trace-id.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No trace ID saved at $ANSWER_FILE."
  exit 1
fi

TRACE_ID=$(cat "$ANSWER_FILE" | tr -d '[:space:]')
if [ ${#TRACE_ID} -ne 32 ]; then
  echo "Saved trace ID '$TRACE_ID' is ${#TRACE_ID} characters, expected 32 hex characters."
  exit 1
fi

PAYLOAD_FILE="/root/kcna-scratch/trace-payload.json"
if [ ! -f "$PAYLOAD_FILE" ]; then
  echo "No trace payload found at $PAYLOAD_FILE."
  exit 1
fi

if ! python3 -m json.tool "$PAYLOAD_FILE" > /dev/null 2>&1; then
  echo "trace-payload.json is not valid JSON."
  exit 1
fi

if ! grep -q "$TRACE_ID" "$PAYLOAD_FILE"; then
  echo "trace-payload.json does not contain the saved trace ID -- did you regenerate one without updating the other?"
  exit 1
fi

echo "Trace payload well-formed with a valid trace ID. Ready to query it back in step 2."
exit 0
