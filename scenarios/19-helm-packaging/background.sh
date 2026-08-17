#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

if ! command -v helm >/dev/null 2>&1; then
  # --max-time so a stalled fetch fails loudly instead of hanging
  # background.sh forever with no error surfaced to Killercoda's Debug panel.
  curl -fsSL --max-time 30 https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

touch /tmp/kcna-background-done
