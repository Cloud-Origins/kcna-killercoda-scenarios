#!/bin/bash
set -e

AND_FILE="/root/kcna-scratch/answer-and.txt"
NOTIN_FILE="/root/kcna-scratch/answer-notin.txt"

if [ ! -f "$AND_FILE" ] || [ ! -f "$NOTIN_FILE" ]; then
  echo "Missing one or both answer files."
  exit 1
fi

AND_ANSWER=$(cat "$AND_FILE" | tr -d '[:space:]')
if [ "$AND_ANSWER" != "shop-prod" ]; then
  echo "AND selector answer is '$AND_ANSWER', expected 'shop-prod'."
  exit 1
fi

NOTIN_ANSWER=$(cat "$NOTIN_FILE" | tr '\n' ' ' | tr -s ' ' | sed 's/^ //;s/ $//')
if [ "$NOTIN_ANSWER" != "api-prod shop-prod" ]; then
  echo "notin selector answer is '$NOTIN_ANSWER', expected 'api-prod shop-prod'."
  exit 1
fi

echo "Both selector queries correct."
exit 0
