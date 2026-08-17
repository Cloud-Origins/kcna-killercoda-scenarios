#!/bin/bash
set -e

ORIGINAL_FILE="/root/kcna-scratch/original-replicas.txt"
if [ ! -f "$ORIGINAL_FILE" ]; then
  echo "No saved original replica count at $ORIGINAL_FILE."
  exit 1
fi

ORIGINAL=$(cat "$ORIGINAL_FILE" | tr -d '[:space:]')

CURRENT=$(kubectl -n guestbook get deploy guestbook-ui -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "")

if [ "$CURRENT" == "5" ]; then
  echo "Deployment 'guestbook-ui' is still at the drifted replica count (5) -- self-heal hasn't reverted it yet. Wait a bit longer and check again."
  exit 1
fi

if [ "$CURRENT" != "$ORIGINAL" ]; then
  echo "Deployment 'guestbook-ui' replicas is '$CURRENT', expected it to have self-healed back to the Git-declared value '$ORIGINAL'."
  exit 1
fi

SYNC=$(kubectl -n argocd get application guestbook -o jsonpath='{.status.sync.status}' 2>/dev/null || echo "")
if [ "$SYNC" != "Synced" ]; then
  echo "Application 'guestbook' sync status is '$SYNC', expected 'Synced' after self-heal."
  exit 1
fi

echo "Confirmed: manual drift was reverted automatically by ArgoCD's self-heal, back to $ORIGINAL replicas."
exit 0
