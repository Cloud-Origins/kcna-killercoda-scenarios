## Prove persistence

Delete the writer pod entirely -- the PVC and its underlying PV stay:

```bash
kubectl delete pod writer-pod
```

Create a fresh pod that mounts the **same** PVC:

```bash
kubectl apply -f assets/reader-pod.yaml
kubectl wait --for=condition=Ready pod/reader-pod --timeout=60s
kubectl exec reader-pod -- cat /data/proof.txt
```
