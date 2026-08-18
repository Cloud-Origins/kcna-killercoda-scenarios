## Label the worker

Find the node that is **not** the control plane -- that's your worker.

Label it:

```bash
kubectl label node <worker-node-name> role=worker-demo
```

<br>

<details><summary>Tip</summary>

You already found the control-plane node's name in step 1 -- the worker is whichever node that isn't:

```bash
kubectl get nodes -l '!node-role.kubernetes.io/control-plane'
```{{exec}}

</details>

<details><summary>Solution</summary>

```bash
WORKER=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')
kubectl label node "$WORKER" role=worker-demo
```

Confirm exactly one node carries the label, and it isn't the control-plane node:

```bash
kubectl get nodes -l role=worker-demo
```{{exec}}

</details>
