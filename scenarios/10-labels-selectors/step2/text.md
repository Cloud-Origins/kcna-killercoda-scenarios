## Query with AND and set-based selectors

A comma between label expressions means AND -- both must match. Save the result of the AND query:

```bash
kubectl get pods -l 'env=prod,app=shop' -o jsonpath='{.items[*].metadata.name}' > /root/kcna-scratch/answer-and.txt
```

Set-based selectors let you say "not in a set." Save the result of excluding `dev`:

```bash
kubectl get pods -l 'env notin (dev)' -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > /root/kcna-scratch/answer-notin.txt
```
