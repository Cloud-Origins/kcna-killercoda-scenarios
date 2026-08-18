## Diagnose a Pod stuck Pending against a taint

Get the tainted node's name and try to force a plain Pod onto it, no toleration:

```bash
NODE=$(cat /root/kcna-scratch/tainted-node.txt)
kubectl run blocked-test --image=nginx:1.27 --overrides="{\"spec\":{\"nodeSelector\":{\"kubernetes.io/hostname\":\"$NODE\"}}}"
```

Check its status:

```bash
kubectl get pod blocked-test
kubectl describe pod blocked-test
```

It's stuck `Pending`. The Events section names the taint blocking it. Write just the taint **key** (not the value or effect) to an answer file:

```bash
kubectl get node $NODE -o jsonpath='{.spec.taints[0].key}' > /root/kcna-scratch/answer-taintkey.txt
```

<br>

<details><summary>Tip</summary>

`kubectl describe pod` truncates long Events -- if you want the taint's key, value, and effect together instead of parsing prose, ask the node directly:

```bash
kubectl get node $NODE -o jsonpath='{.spec.taints}'
```{{exec}}

</details>

<details><summary>Solution</summary>

`kubectl describe pod blocked-test` Events should show something like `0/N nodes are available: 1 node(s) had untolerated taint {dedicated: labs}...`. The taint key is `dedicated`:

```bash
kubectl get node $NODE -o jsonpath='{.spec.taints[0].key}' > /root/kcna-scratch/answer-taintkey.txt
```

</details>
