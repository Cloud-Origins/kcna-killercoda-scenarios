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
