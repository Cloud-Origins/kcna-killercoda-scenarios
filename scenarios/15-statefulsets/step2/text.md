## Prove stable identity across a pod delete

Write a marker file into `data-0`'s volume:

```bash
kubectl exec data-0 -- sh -c "echo kcna-sts-proof > /usr/share/nginx/html/proof.txt"
```

Delete the pod outright:

```bash
kubectl delete pod data-0
kubectl wait --for=condition=Ready pod/data-0 --timeout=60s
```

A Deployment would have replaced it with a new, differently-named pod. Confirm the StatefulSet didn't -- same name came back, and prove the same storage came back with it:

```bash
kubectl get pod data-0
kubectl exec data-0 -- cat /usr/share/nginx/html/proof.txt
```
