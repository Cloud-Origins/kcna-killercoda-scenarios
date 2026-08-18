## Query real scrape targets through the Prometheus API

Port-forward the server in the background:

```bash
kubectl -n monitoring port-forward svc/prometheus-server 9090:80 > /tmp/portforward.log 2>&1 &
sleep 5
```

Query the `up` metric -- `1` means Prometheus successfully scraped that target on its last attempt:

```bash
curl -s 'http://localhost:9090/api/v1/query?query=up' | tee /root/kcna-scratch/up-query.json
```

Grafana would draw this as a dashboard panel; the number underneath is exactly this API response. Confirm at least one target shows `"value":[...,"1"]` in the output before moving on.

<br>

<details><summary>Solution</summary>

`/root/kcna-scratch/up-query.json` should contain `"status":"success"` and at least one result with value `"1"` -- a target Prometheus successfully scraped on its last attempt:

```bash
grep -o '"status":"[a-z]*"' /root/kcna-scratch/up-query.json
```{{exec}}

</details>
