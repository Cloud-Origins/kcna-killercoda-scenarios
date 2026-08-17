#!/bin/bash
set -e

FILE="/root/kcna-scratch/quiz-2.txt"
if [ ! -f "$FILE" ]; then
  echo "No answer file found at $FILE."
  exit 1
fi

KEY=("B" "C" "B" "B" "D")
mapfile -t GIVEN < <(tr -d '\r' < "$FILE" | tr '[:lower:]' '[:upper:]' | sed '/^$/d')

if [ "${#GIVEN[@]}" -ne 5 ]; then
  echo "Expected exactly 5 answers, got ${#GIVEN[@]}."
  exit 1
fi

CORRECT=0
for i in 0 1 2 3 4; do
  if [ "${GIVEN[$i]}" == "${KEY[$i]}" ]; then
    CORRECT=$((CORRECT + 1))
  fi
done

if [ "$CORRECT" -lt 5 ]; then
  echo "Scored $CORRECT/5. Review the missed questions and update /root/kcna-scratch/quiz-2.txt."
  exit 1
fi

echo "Scored 5/5."
exit 0
