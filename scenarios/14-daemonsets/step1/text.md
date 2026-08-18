## Create a DaemonSet

Create a DaemonSet named `node-logger`:
- image `busybox:1.36`
- keep-alive command `sh -c "tail -f /dev/null"`
- pod label `app: node-logger`

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-logger
spec:
  selector:
    matchLabels:
      app: node-logger
  template:
    metadata:
      labels:
        app: node-logger
    spec:
      containers:
        - name: node-logger
          image: busybox:1.36
          command: ["sh", "-c", "tail -f /dev/null"]
```

Save as `/root/kcna-scratch/daemonset.yaml`, apply it, then check:

```bash
kubectl get ds node-logger
kubectl get pods -l app=node-logger -o wide
```

`DESIRED` should equal `CURRENT` and `READY`. If it's fewer than your total node count, a node is tainted against scheduling -- that's expected, not a bug. Keep going to step 2.

<br>

<details><summary>Solution</summary>

`kubectl get ds node-logger` should show `DESIRED`, `CURRENT`, and `READY` all equal to each other (at least `1`). They only need to equal your *total* node count once the control-plane taint is tolerated in step 2 -- until then, a tainted node not covered is expected.

</details>
