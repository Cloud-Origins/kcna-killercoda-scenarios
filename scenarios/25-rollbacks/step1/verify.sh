#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-stalled.txt"
if [ ! -f "$ANSWER_FILE" ]; then
  echo "No answer file found at $ANSWER_FILE. Run the rollout status check that writes it."
  exit 1
fi

BAD_PODS=$(kubectl get pods -l app=web -o jsonpath='{range .items[*]}{.status.containerStatuses[0].state.waiting.reason}{"\n"}{end}' 2>/dev/null | grep -Ec 'ImagePull|ErrImage' || true)
if [ "$BAD_PODS" -lt 1 ]; then
  echo "No pod is showing an image pull failure yet. Did you set the broken image tag?"
  exit 1
fi

READY_OLD=$(kubectl get pods -l app=web -o jsonpath='{range .items[*]}{.spec.containers[0].image}{" "}{.status.containerStatuses[0].ready}{"\n"}{end}' 2>/dev/null | grep -c "^nginx:1.26 true" || true)
if [ "$READY_OLD" -lt 1 ]; then
  echo "No nginx:1.26 pod is still Ready -- the rollout should have preserved at least one working old pod."
  exit 1
fi

echo "Confirmed: rollout stalled on the broken image, old pods still serving."
exit 0
