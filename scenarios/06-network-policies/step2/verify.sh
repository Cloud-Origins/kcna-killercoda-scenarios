#!/bin/bash
set -e

LABEL_VALUE=$(kubectl get networkpolicy backend-allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}')

if [ "$LABEL_VALUE" != "frontend" ]; then
  echo "Policy still doesn't select app=frontend (found: '$LABEL_VALUE')."
  exit 1
fi

RESULT=$(kubectl exec frontend -- wget -qO- --timeout=5 backend-svc 2>&1 || echo "FAILED")
if echo "$RESULT" | grep -qi "FAILED"; then
  echo "Traffic still doesn't reach backend-svc from frontend."
  exit 1
fi

echo "Correct -- policy fixed, frontend can now reach backend-svc."
exit 0
