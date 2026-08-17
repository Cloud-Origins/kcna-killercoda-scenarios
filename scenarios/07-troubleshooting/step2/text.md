## Fix the service with no endpoints

`webapp` is running now, but the Service still doesn't route to it:

```bash
kubectl get endpoints webapp-svc
```

Empty. A Service with no matching pods has no endpoints -- traffic goes nowhere.

Compare what the Service is looking for against what the pod actually has:

```bash
kubectl get svc webapp-svc -o yaml | grep -A2 selector
kubectl get pod -l app=webapp --show-labels
```

Fix the selector so it matches the pod's real label:

```bash
kubectl edit svc webapp-svc
```
