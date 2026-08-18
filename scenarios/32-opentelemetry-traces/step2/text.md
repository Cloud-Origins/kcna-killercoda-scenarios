## Query the trace back out of Jaeger

Fetch your exact trace by ID from Jaeger's query API -- this is the same API the Jaeger UI itself calls:

```bash
TRACE_ID=$(cat /root/kcna-scratch/answer-trace-id.txt)
kubectl run trace-query --image=curlimages/curl:latest --rm -i --restart=Never --command -- \
  curl -s "http://jaeger:16686/api/traces/${TRACE_ID}" | tee /root/kcna-scratch/queried-trace.json
```

Confirm your span survived the round trip -- name, service, everything:

```bash
grep -o '"operationName":"[^"]*"' /root/kcna-scratch/queried-trace.json
grep -o '"serviceName":"[^"]*"' /root/kcna-scratch/queried-trace.json
```

That's the entire tracing pipeline in one request: ingest over OTLP, store, index by trace ID, query back out.

<br>

<details><summary>Solution</summary>

`/root/kcna-scratch/queried-trace.json` should contain:

- `"operationName":"process-request"`
- `"serviceName":"kcna-demo-service"`

Both `grep -o` commands above should print a matching line. If the file is empty or the query returned no data, double check `$TRACE_ID` matches the one saved in step 1's `answer-trace-id.txt`.

</details>
