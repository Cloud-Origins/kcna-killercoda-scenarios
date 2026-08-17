#!/bin/bash
set -e

check_pod() {
  local name=$1 app=$2 env=$3
  local a=$(kubectl get pod "$name" -o jsonpath='{.metadata.labels.app}' 2>/dev/null || echo "")
  local e=$(kubectl get pod "$name" -o jsonpath='{.metadata.labels.env}' 2>/dev/null || echo "")
  if [ "$a" != "$app" ] || [ "$e" != "$env" ]; then
    echo "Pod '$name' has labels app=$a,env=$e, expected app=$app,env=$env."
    exit 1
  fi
}

check_pod shop-prod shop prod
check_pod shop-dev shop dev
check_pod api-prod api prod

echo "All three Pods correctly labeled."
exit 0
