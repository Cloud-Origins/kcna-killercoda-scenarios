#!/bin/bash
set -e

ANSWER_FILE="/root/kcna-scratch/answer-controlplane.txt"

if [ ! -f "$ANSWER_FILE" ]; then
  echo "Answer file not found. Did you write the control plane node's name to $ANSWER_FILE?"
  exit 1
fi

ANSWER=$(cat "$ANSWER_FILE" | tr -d '[:space:]')

ACTUAL_CP=$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}')

if [ "$ANSWER" != "$ACTUAL_CP" ]; then
  echo "Incorrect. You answered '$ANSWER', but the control plane node is '$ACTUAL_CP'."
  echo "Hint: check which node's kube-system pods include etcd and kube-apiserver."
  exit 1
fi

echo "Correct -- $ACTUAL_CP is the control plane node."
exit 0
