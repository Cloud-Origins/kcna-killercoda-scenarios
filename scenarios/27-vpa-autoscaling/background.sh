#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

# timeout so a stalled fetch fails loudly instead of hanging background.sh
# forever with no error surfaced to Killercoda's Debug panel.
timeout 60 kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system patch deployment metrics-server --type=json -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
kubectl -n kube-system wait --for=condition=Available deployment/metrics-server --timeout=180s
for i in $(seq 1 20); do
  if kubectl top nodes >/dev/null 2>&1; then
    break
  fi
  sleep 10
done

# VPA (updater, recommender, admission-controller) has no single install
# manifest -- the project ships an install script instead. Both network
# steps are timeout-wrapped so a stall fails loudly instead of hanging
# background.sh forever with no error surfaced to Killercoda's Debug panel.
timeout 60 git clone --depth 1 https://github.com/kubernetes/autoscaler.git /root/kcna-scratch/autoscaler
cd /root/kcna-scratch/autoscaler/vertical-pod-autoscaler
timeout 300 ./hack/vpa-up.sh
kubectl -n kube-system wait --for=condition=Available deployment/vpa-recommender --timeout=180s
kubectl -n kube-system wait --for=condition=Available deployment/vpa-updater --timeout=180s
kubectl -n kube-system wait --for=condition=Available deployment/vpa-admission-controller --timeout=180s

touch /tmp/kcna-background-done
