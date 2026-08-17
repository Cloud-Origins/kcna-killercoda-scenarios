#!/bin/bash
# Dynamic quality gate: run a scenario's background.sh against a real
# 2-node kind cluster, exactly as Killercoda would run it (real root, real
# Linux -- no path substitution or environment hacks). Requires passwordless
# sudo and a Linux host; this is what CI runs, and what to reach for on any
# Linux dev machine. On macOS, /root doesn't exist at all -- use CI instead
# of trying to approximate this locally.
#
# Usage: scripts/test-scenario.sh <scenario-name>
set -euo pipefail

SCENARIO="${1:?Usage: $0 <scenario-name>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCENARIO_DIR="$REPO_ROOT/scenarios/$SCENARIO"
KIND_CONFIG="$REPO_ROOT/scripts/kind-config.yaml"
CLUSTER_NAME="kcna-test-$SCENARIO"
MARKER="/tmp/kcna-background-done"

if [ ! -d "$SCENARIO_DIR" ]; then
  echo "No such scenario: $SCENARIO" >&2
  exit 1
fi

cleanup() {
  kind delete cluster --name "$CLUSTER_NAME" >/dev/null 2>&1 || true
  rm -f "/tmp/kind-${CLUSTER_NAME}-kubeconfig"
}
trap cleanup EXIT

KUBECONFIG_PATH="/tmp/kind-${CLUSTER_NAME}-kubeconfig"
kind create cluster --name "$CLUSTER_NAME" --config "$KIND_CONFIG" --kubeconfig "$KUBECONFIG_PATH"
export KUBECONFIG="$KUBECONFIG_PATH"
kubectl wait --for=condition=Ready node --all --timeout=120s

cd "$SCENARIO_DIR"
sudo rm -f "$MARKER"
sudo -E env "KUBECONFIG=$KUBECONFIG" "PATH=$PATH" bash background.sh

if [ ! -f "$MARKER" ]; then
  echo "FAIL: $SCENARIO -- background.sh exited without touching $MARKER" >&2
  exit 1
fi

echo "PASS: $SCENARIO"
