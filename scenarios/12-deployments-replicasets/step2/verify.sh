#!/bin/bash
set -e

BEFORE="/root/kcna-scratch/pods-before.txt"
AFTER="/root/kcna-scratch/pods-after.txt"

if [ ! -f "$BEFORE" ] || [ ! -f "$AFTER" ]; then
  echo "Missing pods-before.txt or pods-after.txt -- capture Pod names before and after the delete."
  exit 1
fi

BEFORE_COUNT=$(sed '/^$/d' "$BEFORE" | wc -l | tr -d ' ')
AFTER_COUNT=$(sed '/^$/d' "$AFTER" | wc -l | tr -d ' ')

if [ "$BEFORE_COUNT" != "3" ] || [ "$AFTER_COUNT" != "3" ]; then
  echo "Expected 3 pod names in each snapshot, got $BEFORE_COUNT before and $AFTER_COUNT after."
  exit 1
fi

if diff -q "$BEFORE" "$AFTER" > /dev/null 2>&1; then
  echo "pods-before.txt and pods-after.txt are identical -- no pod was actually deleted and replaced."
  exit 1
fi

REPLICAS=$(kubectl get deploy web -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "")
READY=$(kubectl get deploy web -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

if [ "$REPLICAS" != "5" ] || [ "$READY" != "5" ]; then
  echo "Deployment 'web' is not scaled to 5/5 ready replicas (spec: $REPLICAS, ready: $READY)."
  exit 1
fi

echo "Self-healing proven and scaled to 5/5 ready replicas."
exit 0
