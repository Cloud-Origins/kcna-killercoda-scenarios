## Fix it

You can't raise the quota (pretend you don't own that namespace's policy) -- free up room instead. Delete `pod-b`, then create `pod-c`:

```bash
kubectl delete pod pod-b -n team-a
kubectl apply -f assets/pod-c.yaml
```

<br>

<details><summary>Solution</summary>

```bash
kubectl get pods -n team-a
```{{exec}}

Expect exactly 2 pods in `team-a`: `pod-a` and `pod-c` running, `pod-b` gone -- within the 2-pod quota.

</details>
