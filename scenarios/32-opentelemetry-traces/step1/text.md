## Send a trace via OTLP/HTTP

Generate a real trace ID (32 hex chars) and span ID (16 hex chars) -- this is what an SDK does automatically, you're doing it by hand once to see it's not magic:

```bash
TRACE_ID=$(openssl rand -hex 16)
SPAN_ID=$(openssl rand -hex 8)
echo "$TRACE_ID" > /root/kcna-scratch/answer-trace-id.txt

START=$(date +%s%N)
END=$((START + 500000000))
```

Build the OTLP/HTTP JSON payload -- this is the actual wire format every OpenTelemetry SDK sends:

```bash
cat <<EOF > /root/kcna-scratch/trace-payload.json
{
  "resourceSpans": [{
    "resource": {
      "attributes": [{"key": "service.name", "value": {"stringValue": "kcna-demo-service"}}]
    },
    "scopeSpans": [{
      "scope": {"name": "kcna-manual-instrumentation"},
      "spans": [{
        "traceId": "$TRACE_ID",
        "spanId": "$SPAN_ID",
        "name": "process-request",
        "kind": 2,
        "startTimeUnixNano": "$START",
        "endTimeUnixNano": "$END"
      }]
    }]
  }]
}
EOF
```

Send it to Jaeger's OTLP receiver from inside the cluster:

```bash
cat /root/kcna-scratch/trace-payload.json | kubectl run trace-sender --image=curlimages/curl:latest --rm -i --restart=Never --command -- \
  curl -s -o /dev/null -w '%{http_code}' -X POST http://jaeger:4318/v1/traces -H "Content-Type: application/json" -d @-
```

A `200` means Jaeger accepted it.
