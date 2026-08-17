#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# kubeadm sandbox clusters use self-signed kubelet certs -- metrics-server
# needs this flag to scrape them at all.
kubectl -n kube-system patch deployment metrics-server --type=json -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
kubectl -n kube-system wait --for=condition=Available deployment/metrics-server --timeout=180s

# Wait until the metrics API is actually serving data, not just the pod being Ready.
for i in $(seq 1 20); do
  if kubectl top nodes >/dev/null 2>&1; then
    break
  fi
  sleep 10
done
