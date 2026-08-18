## Read logs and exec directly through the runtime

Still on the node running `runtime-demo`, read its logs straight from the runtime -- this is exactly what `kubectl logs` does under the hood, minus the API server hop:

```bash
sudo crictl logs "$CID" 2>&1 | tail -5
```

Now write a file inside the container using `crictl exec`, not `kubectl exec`:

```bash
sudo crictl exec "$CID" sh -c "echo crictl-was-here > /tmp/proof.txt"
```

Prove it actually landed in the real container -- read it back with `kubectl exec` from your original terminal, a completely different tool talking to the same container:

```bash
kubectl exec runtime-demo -- cat /tmp/proof.txt
```

<br>

<details><summary>Solution</summary>

`kubectl exec runtime-demo -- cat /tmp/proof.txt` should print exactly `crictl-was-here` -- proof that `crictl exec` (talking to the runtime) and `kubectl exec` (talking through the API server and kubelet) land in the same container:

```bash
kubectl exec runtime-demo -- cat /tmp/proof.txt
```{{exec}}

</details>
