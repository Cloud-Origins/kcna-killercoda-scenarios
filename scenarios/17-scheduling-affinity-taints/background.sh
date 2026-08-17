#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

TARGET=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
if [ -z "$TARGET" ]; then
  TARGET=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
fi

kubectl taint node "$TARGET" dedicated=labs:NoSchedule --overwrite
echo "$TARGET" > /root/kcna-scratch/tainted-node.txt

touch /tmp/kcna-background-done
