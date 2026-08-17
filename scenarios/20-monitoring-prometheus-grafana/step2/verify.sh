#!/bin/bash
set -e

RESULT_FILE="/root/kcna-scratch/up-query.json"
if [ ! -f "$RESULT_FILE" ]; then
  echo "No saved query result at $RESULT_FILE. Did you run the curl against the Prometheus API?"
  exit 1
fi

if ! grep -q '"status":"success"' "$RESULT_FILE"; then
  echo "Saved query result does not show a successful Prometheus API response."
  exit 1
fi

if ! grep -q '"1"' "$RESULT_FILE"; then
  echo "No target with value '1' found -- Prometheus does not appear to have a healthy scrape target yet."
  exit 1
fi

echo "Confirmed real scrape targets reporting up=1 via the Prometheus API."
exit 0
