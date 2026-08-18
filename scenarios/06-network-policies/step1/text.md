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

<br>

<details><summary>Tip</summary>

Eyeballing YAML is error-prone for typos -- diff the two values instead:

```bash
diff <(kubectl get networkpolicy backend-allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}') <(kubectl get pod frontend -o jsonpath='{.metadata.labels.app}')
```{{exec}}

</details>

<details><summary>Solution</summary>

```bash
kubectl get networkpolicy backend-allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' > /root/kcna-scratch/answer-bug.txt
cat /root/kcna-scratch/answer-bug.txt
```

</details>
