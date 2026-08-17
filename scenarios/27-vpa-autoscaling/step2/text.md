## Watch VPA evict and resize the pod

With `updateMode: Auto`, VPA doesn't just recommend -- its updater evicts a badly-sized pod, and its admission-controller rewrites the resource requests on the replacement pod as it's recreated. Watch for a pod restart:

```bash
kubectl get pods -l app=sized-app -w
```

Once you see a new pod come up, compare its actual CPU request to the original `10m`:

```bash
kubectl get pods -l app=sized-app -o jsonpath='{.items[0].spec.containers[0].resources.requests.cpu}{"\n"}'
```

VPA's updater runs on its own interval, so this can take a couple of minutes -- give it time before assuming it's stuck.
