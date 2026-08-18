## Query with AND and set-based selectors

A comma between label expressions means AND -- both must match. Write a selector that matches only pods with `env=prod` **and** `app=shop`, and save the matching pod name(s):

```bash
kubectl get pods -l '<your AND selector>' -o jsonpath='{.items[*].metadata.name}' > /root/kcna-scratch/answer-and.txt
```

Set-based selectors let you say "not in a set." Write a selector that excludes anything with `env=dev`, and save the result, one name per line, sorted:

```bash
kubectl get pods -l '<your notin selector>' -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > /root/kcna-scratch/answer-notin.txt
```

<br>

<details><summary>Tip</summary>

A comma-separated selector like `app=api,env=prod` is shorthand for AND -- try it against a different combination first to see the mechanics:

```bash
kubectl get pods -l 'app=api,env=prod'
```{{exec}}

Set-based `notin` works the same way but on a set of values -- try excluding a different value to see the syntax:

```bash
kubectl get pods -l 'env notin (prod)'
```{{exec}}

</details>

<details><summary>Solution</summary>

```bash
kubectl get pods -l 'env=prod,app=shop' -o jsonpath='{.items[*].metadata.name}' > /root/kcna-scratch/answer-and.txt
kubectl get pods -l 'env notin (dev)' -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > /root/kcna-scratch/answer-notin.txt
```

Expected: `answer-and.txt` contains `shop-prod`; `answer-notin.txt` contains `api-prod` and `shop-prod`, one per line, sorted.

</details>
