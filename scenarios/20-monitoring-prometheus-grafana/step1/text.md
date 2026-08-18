## Install a lean Prometheus stack

Install into a dedicated `monitoring` namespace, with the heavier optional pieces (Alertmanager, Pushgateway, persistent storage) switched off to keep it light:

```bash
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring --create-namespace \
  --set alertmanager.enabled=false \
  --set prometheus-pushgateway.enabled=false \
  --set server.persistentVolume.enabled=false
```

Wait for the server to come up:

```bash
kubectl -n monitoring wait --for=condition=Ready pod -l app.kubernetes.io/name=prometheus,app.kubernetes.io/component=server --timeout=180s
kubectl -n monitoring get pods
```

<br>

<details><summary>Solution</summary>

The Prometheus server pod in the `monitoring` namespace should report `ready: true`:

```bash
kubectl -n monitoring get pods -l app.kubernetes.io/name=prometheus,app.kubernetes.io/component=server -o jsonpath='{.items[0].status.containerStatuses[0].ready}{"\n"}'
```{{exec}}

</details>
