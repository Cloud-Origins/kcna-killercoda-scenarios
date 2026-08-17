## Diagnose the rejection

Try to create the third pod:

```bash
kubectl apply -f assets/pod-c.yaml
```

It will be rejected. Find out why:

```bash
kubectl describe resourcequota team-a-quota -n team-a
kubectl get events -n team-a --sort-by='.lastTimestamp'
```

Write the name of the ResourceQuota that's blocking you to `/root/kcna-scratch/answer-quota.txt`:

```bash
echo "<quota-name>" > /root/kcna-scratch/answer-quota.txt
```
