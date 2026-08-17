#!/bin/bash
# Pre-stages the environment before the learner's timer starts.
# Nothing to build here -- the kubeadm-2nodes backend already gives us
# a running control-plane + worker pair. We just wait for it to be ready
# and set up a scratch dir for the learner's answer files.

set -e

echo "Waiting for both nodes to reach Ready..."
kubectl wait --for=condition=Ready node --all --timeout=120s

mkdir -p /root/kcna-scratch
