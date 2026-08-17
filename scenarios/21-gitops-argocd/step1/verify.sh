#!/bin/bash
set -e

SYNC=$(kubectl -n argocd get application guestbook -o jsonpath='{.status.sync.status}' 2>/dev/null || echo "")
HEALTH=$(kubectl -n argocd get application guestbook -o jsonpath='{.status.health.status}' 2>/dev/null || echo "")

if [ "$SYNC" != "Synced" ]; then
  echo "Application 'guestbook' sync status is '$SYNC', expected 'Synced'."
  exit 1
fi

if [ "$HEALTH" != "Healthy" ]; then
  echo "Application 'guestbook' health status is '$HEALTH', expected 'Healthy'."
  exit 1
fi

DEPLOY_COUNT=$(kubectl -n guestbook get deploy --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$DEPLOY_COUNT" -lt 1 ]; then
  echo "No Deployments found in the 'guestbook' namespace -- ArgoCD did not actually apply the manifests."
  exit 1
fi

echo "Application 'guestbook' Synced and Healthy, resources actually present in the cluster."
exit 0
