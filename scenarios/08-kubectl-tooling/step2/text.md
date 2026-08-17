## Inspect a resource schema with kubectl explain

You don't need the docs site to know a field's type -- the API schema is built into `kubectl`:

```bash
kubectl explain pod.spec.terminationGracePeriodSeconds
```

Look at the `TYPE:` line in the output. Save just that value (for example `integer` or `string`, lowercase, no extra text):

```bash
echo "integer" > /root/kcna-scratch/answer-fieldtype.txt
```

(Replace `integer` above with whatever the real `TYPE:` line actually says -- don't just copy this example.)
