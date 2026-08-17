## Diagnose the block

Confirm the symptom first:

```bash
kubectl exec frontend -- wget -qO- --timeout=5 backend-svc
```

It will time out. Inspect the policy that's supposed to allow this:

```bash
kubectl get networkpolicy backend-allow-frontend -o yaml
kubectl get pod frontend --show-labels
```

Compare the `podSelector` inside the policy's `ingress.from` block against `frontend`'s actual labels. Write the incorrect label **value** you find in the policy (not the correct one) to `/root/kcna-scratch/answer-bug.txt`:

```bash
echo "<value-found-in-policy>" > /root/kcna-scratch/answer-bug.txt
```
