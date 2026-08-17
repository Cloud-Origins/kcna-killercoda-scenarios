#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

if ! command -v helm >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  --namespace monitoring --create-namespace \
  --set alertmanager.enabled=false \
  --set prometheus-pushgateway.enabled=false \
  --set kube-state-metrics.enabled=false \
  --set prometheus-node-exporter.enabled=false \
  --set server.persistentVolume.enabled=false

# Grafana provisioned with its Prometheus datasource baked in from the
# start -- this is how production Grafana is actually configured
# (as code), not clicked together by hand.
helm install grafana grafana/grafana \
  --namespace monitoring \
  --set adminPassword=kcna-admin-2026 \
  --set persistence.enabled=false \
  --set 'datasources.datasources\.yaml.apiVersion=1' \
  --set 'datasources.datasources\.yaml.datasources[0].name=Prometheus' \
  --set 'datasources.datasources\.yaml.datasources[0].type=prometheus' \
  --set 'datasources.datasources\.yaml.datasources[0].url=http://prometheus-server.monitoring.svc.cluster.local' \
  --set 'datasources.datasources\.yaml.datasources[0].access=proxy' \
  --set 'datasources.datasources\.yaml.datasources[0].isDefault=true'

kubectl -n monitoring wait --for=condition=Ready pod -l app.kubernetes.io/name=prometheus,app.kubernetes.io/component=server --timeout=180s
kubectl -n monitoring wait --for=condition=Ready pod -l app.kubernetes.io/name=grafana --timeout=180s
