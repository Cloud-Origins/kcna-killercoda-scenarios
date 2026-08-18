## Inspect a resource schema with kubectl explain

You don't need the docs site to know a field's type -- the API schema is built into `kubectl`:

```bash
kubectl explain pod.spec.terminationGracePeriodSeconds
```

Look at the `TYPE:` line in the output, then save exactly what it says (lowercase, no extra text):

```bash
echo "<what TYPE: reported>" > /root/kcna-scratch/answer-fieldtype.txt
```

<br>

<details><summary>Solution</summary>

`terminationGracePeriodSeconds` is backed by an `int64` in the API, so `kubectl explain` should report `TYPE: <integer>` -- write `integer` (case-insensitive) to the answer file:

```bash
kubectl explain pod.spec.terminationGracePeriodSeconds | grep -i '^TYPE:'
```{{exec}}

</details>
