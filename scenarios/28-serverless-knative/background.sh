#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

KN_VERSION="knative-v1.23.0"

# timeout on every fetch so a stall fails loudly instead of hanging
# background.sh forever with no error surfaced to Killercoda's Debug panel.
timeout 60 kubectl apply -f "https://github.com/knative/serving/releases/download/${KN_VERSION}/serving-crds.yaml"
kubectl wait --for=condition=Established crd --all --timeout=60s
timeout 60 kubectl apply -f "https://github.com/knative/serving/releases/download/${KN_VERSION}/serving-core.yaml"

timeout 60 kubectl apply -f "https://github.com/knative-extensions/net-kourier/releases/download/${KN_VERSION}/kourier.yaml"
kubectl patch configmap/config-network -n knative-serving --type merge \
  -p '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

# Shrink the default 60s stable-window / 30s grace-period so scale-to-zero
# is observable in a compressed scenario instead of a 90-second wait.
kubectl patch configmap/config-autoscaler -n knative-serving --type merge \
  -p '{"data":{"stable-window":"10s","scale-to-zero-grace-period":"10s"}}'

kubectl -n knative-serving wait --for=condition=Available deployment --all --timeout=240s
kubectl -n kourier-system wait --for=condition=Available deployment --all --timeout=240s

touch /tmp/kcna-background-done
