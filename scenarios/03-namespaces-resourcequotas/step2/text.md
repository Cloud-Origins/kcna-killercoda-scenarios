## Fix it

You can't raise the quota (pretend you don't own that namespace's policy) -- free up room instead. Delete `pod-b`, then create `pod-c`:

```bash
kubectl delete pod pod-b -n team-a
kubectl apply -f assets/pod-c.yaml
```
