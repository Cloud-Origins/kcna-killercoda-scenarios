#!/bin/bash
set -e

REVISION_COUNT=$(helm history webapp -o json 2>/dev/null | grep -o '"revision":[0-9]*' | wc -l | tr -d ' ')
if [ "$REVISION_COUNT" -lt 3 ]; then
  echo "Helm release 'webapp' has $REVISION_COUNT revisions, expected at least 3 (install, upgrade, rollback)."
  exit 1
fi

DEPLOY=$(kubectl get deploy -l app.kubernetes.io/instance=webapp -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
REPLICAS=$(kubectl get deploy "$DEPLOY" -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "")

if [ "$REPLICAS" != "2" ]; then
  echo "Deployment '$DEPLOY' spec.replicas is '$REPLICAS', expected 2 after rolling back to the original release."
  exit 1
fi

echo "Upgrade and rollback both confirmed in helm history, back to 2 replicas."
exit 0
