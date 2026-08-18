## Tolerate the control-plane taint to cover all nodes

Real node agents (like `kube-proxy`) run on every node, control-plane included, because they're built with a toleration for the `node-role.kubernetes.io/control-plane:NoSchedule` taint. Add the same toleration to `node-logger`:

```bash
kubectl edit daemonset node-logger
```

Add under `spec.template.spec`:

```yaml
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
          effect: NoSchedule
```

Confirm it now covers every node in the cluster:

```bash
kubectl get nodes --no-headers | wc -l
kubectl get ds node-logger
```

<br>

<details><summary>Solution</summary>

After the toleration is added, `kubectl get ds node-logger`'s `DESIRED` and `READY` should both equal the total node count from `kubectl get nodes --no-headers | wc -l` -- every node, including the tainted control-plane one, now runs the DaemonSet's pod.

</details>
