## Build a dashboard and prove its data is live

Create a dashboard with one panel, querying `up`, through the API -- this is exactly what clicking "New Dashboard" in the UI does underneath:

```bash
cat <<'EOF' > /root/kcna-scratch/dashboard.json
{
  "dashboard": {
    "id": null,
    "title": "KCNA Cluster Health",
    "panels": [
      {
        "id": 1,
        "title": "Scrape targets up",
        "type": "timeseries",
        "targets": [ { "expr": "up", "refId": "A" } ],
        "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 }
      }
    ]
  },
  "overwrite": true
}
EOF

curl -s -u admin:kcna-admin-2026 -H "Content-Type: application/json" \
  -X POST http://localhost:3000/api/dashboards/db \
  -d @/root/kcna-scratch/dashboard.json | tee /root/kcna-scratch/dashboard-result.json
```

The dashboard now exists, but existing isn't the same as working. Find your datasource's ID and query it exactly the way the panel does, through Grafana's own proxy -- if this returns real values, the panel would show real values too:

```bash
DS_ID=$(grep -o '"id":[0-9]*' /root/kcna-scratch/datasources.json | head -1 | grep -o '[0-9]*')
curl -s -u admin:kcna-admin-2026 "http://localhost:3000/api/datasources/proxy/${DS_ID}/api/v1/query?query=up" | tee /root/kcna-scratch/panel-data.json
```

<br>

<details><summary>Solution</summary>

Both `/root/kcna-scratch/dashboard-result.json` and `/root/kcna-scratch/panel-data.json` should contain `"status":"success"`, and `panel-data.json` should contain a result with value `"1"` -- a real, currently-up scrape target, not a static number someone typed in:

```bash
grep -o '"status":"[a-z]*"' /root/kcna-scratch/dashboard-result.json /root/kcna-scratch/panel-data.json
```{{exec}}

</details>
