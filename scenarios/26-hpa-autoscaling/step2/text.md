## Generate real CPU load and watch it scale out

Switch the container from idle to a genuine CPU-burning busy loop -- this is real load, not a fake metric:

```bash
kubectl patch deployment cpu-app --type=json -p='[{"op":"replace","path":"/spec/template/spec/containers/0/command","value":["sh","-c","while true; do :; done"]}]'
kubectl rollout status deployment/cpu-app --timeout=60s
```

Watch the HPA notice and react -- this takes a minute or two, metrics-server scrapes on an interval and the HPA controller only re-evaluates periodically:

```bash
kubectl get hpa cpu-app -w
```

Once `REPLICAS` climbs past 1, you've watched a real autoscale event, not a status field someone set by hand.
