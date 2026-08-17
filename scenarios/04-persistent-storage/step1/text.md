## Bind a PVC and write to it

Create the PVC (matches `data-pv`'s storage class and access mode):

```bash
kubectl apply -f assets/pvc.yaml
kubectl get pvc data-pvc
```

Confirm it bound to `data-pv` (`STATUS` should be `Bound`), then create the writer pod, which mounts the PVC and writes a marker file:

```bash
kubectl apply -f assets/writer-pod.yaml
kubectl wait --for=condition=Ready pod/writer-pod --timeout=60s
```
