## Go idle and watch it scale to zero

That's it -- stop sending requests. The idle window here is compressed to 10 seconds (a real deployment defaults to 60), so just wait and watch:

```bash
kubectl get pods -l serving.knative.dev/service=hello -w
```

Within roughly 20-30 seconds of no traffic, the last pod terminates. `kubectl get pods` for this service goes to zero results -- not "0 replicas shown as a number," actually zero Pods running. Confirm:

```bash
kubectl get pods -l serving.knative.dev/service=hello
```
