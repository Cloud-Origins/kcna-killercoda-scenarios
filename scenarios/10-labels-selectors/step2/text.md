## Query with AND and set-based selectors

A comma between label expressions means AND -- both must match. Write a selector that matches only pods with `env=prod` **and** `app=shop`, and save the matching pod name(s):

```bash
kubectl get pods -l '<your AND selector>' -o jsonpath='{.items[*].metadata.name}' > /root/kcna-scratch/answer-and.txt
```

Set-based selectors let you say "not in a set." Write a selector that excludes anything with `env=dev`, and save the result, one name per line, sorted:

```bash
kubectl get pods -l '<your notin selector>' -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > /root/kcna-scratch/answer-notin.txt
```
