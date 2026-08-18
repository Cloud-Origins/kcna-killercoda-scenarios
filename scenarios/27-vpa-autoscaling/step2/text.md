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

<br>

<details><summary>Solution</summary>

After VPA's updater evicts the old pod and the admission controller rewrites requests on the replacement, the CPU request reported by:

```bash
kubectl get pods -l app=sized-app -o jsonpath='{.items[0].spec.containers[0].resources.requests.cpu}{"\n"}'
```{{exec}}

should be anything **other than** the original `10m` -- a higher value matching (or close to) the VPA recommendation from Step 1. If it still reads `10m`, the updater hasn't acted yet; wait another minute and re-run.

</details>
