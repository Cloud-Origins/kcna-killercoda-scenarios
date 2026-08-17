#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s

# Install the ingress controller -- boilerplate, not the tested concept.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

kubectl apply -f assets/backends.yaml
kubectl wait --for=condition=Available deployment/app1 --timeout=90s
kubectl wait --for=condition=Available deployment/app2 --timeout=90s
