## Inspect a resource schema with kubectl explain

You don't need the docs site to know a field's type -- the API schema is built into `kubectl`:

```bash
kubectl explain pod.spec.terminationGracePeriodSeconds
```

Look at the `TYPE:` line in the output, then save exactly what it says (lowercase, no extra text):

```bash
echo "<what TYPE: reported>" > /root/kcna-scratch/answer-fieldtype.txt
```
