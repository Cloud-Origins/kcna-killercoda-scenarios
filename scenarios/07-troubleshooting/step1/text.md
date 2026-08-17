## Fix the pod that won't start

```bash
kubectl get pods
```

It's not `Running`. Find out why:

```bash
kubectl describe pod -l app=webapp
```

Fix the root cause directly in the cluster (edit the Deployment, don't just delete and hope):

```bash
kubectl edit deployment webapp
```
