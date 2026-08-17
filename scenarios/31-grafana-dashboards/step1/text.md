## Confirm Grafana and its Prometheus datasource

Port-forward Grafana in the background:

```bash
kubectl -n monitoring port-forward svc/grafana 3000:80 > /root/kcna-scratch/portforward.log 2>&1 &
sleep 5
```

Check it's actually healthy, not just Running:

```bash
curl -s http://localhost:3000/api/health
```

Log in with the admin credentials (`admin` / `kcna-admin-2026`) and confirm the datasource that was provisioned for you:

```bash
curl -s -u admin:kcna-admin-2026 http://localhost:3000/api/datasources | tee /root/kcna-scratch/datasources.json
```

Check what came back: how many datasources are listed, what `type` each one is, and what `url` it points at. That's what confirms (or doesn't) that the provisioning in `background.sh` actually wired Grafana to the right Prometheus.
