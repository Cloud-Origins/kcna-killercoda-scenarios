## Confirm Grafana and its Prometheus datasource

This step is a sanity check, not a puzzle: `background.sh` provisioned Grafana's datasource declaratively (Helm `--set` values, not clicked into the UI). The skill being tested is verifying infrastructure-as-code did what it claimed -- via the API, the same way you'd check it in a real pipeline -- not diagnosing a hidden bug.

Run these in order:

```bash
kubectl -n monitoring port-forward svc/grafana 3000:80 > /tmp/portforward.log 2>&1 &
sleep 5
curl -s http://localhost:3000/api/health
curl -s -u admin:kcna-admin-2026 http://localhost:3000/api/datasources | tee /root/kcna-scratch/datasources.json
```

Look at the last command's output: how many datasources, what `type`, what `url`. That's your confirmation the Helm-provisioned config actually landed.

<br>

<details><summary>Solution</summary>

You should see exactly one datasource: `"type":"prometheus"`, `"url":"http://prometheus-server.monitoring.svc.cluster.local"`. If `curl` returned nothing at all, the port-forward likely didn't establish -- check `/tmp/portforward.log`.

</details>
