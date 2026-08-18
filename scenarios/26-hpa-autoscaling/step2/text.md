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

<br>

<details><summary>Solution</summary>

After the busy-loop patch, `kubectl get deploy cpu-app -o jsonpath='{.spec.template.spec.containers[0].command[2]}'` should return `while true; do :; done`.

Give it a minute or two, then `kubectl get hpa cpu-app` should show `REPLICAS` greater than `1` (up to `4`, the configured `maxReplicas`) and `TARGETS` well above `50%` before it starts climbing back down as replicas absorb the load. If `currentReplicas` is still `1` after several minutes, check `kubectl describe hpa cpu-app` for scaling events.

</details>
