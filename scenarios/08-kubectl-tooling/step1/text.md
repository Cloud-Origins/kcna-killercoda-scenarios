## Set a default-namespace context and extract with jsonpath

Right now every command needs `-n dev` or `-n staging` typed out. Fix that by setting the current context's default namespace to `dev`:

```bash
kubectl config set-context --current --namespace=dev
```

Confirm it stuck:

```bash
kubectl config view --minify --output 'jsonpath={..namespace}'
```

Now, without typing `-n dev` (it's the default now), pull just the pod's name out with jsonpath and save it:

```bash
kubectl get pods -o jsonpath='{.items[0].metadata.name}' > /root/kcna-scratch/answer-podname.txt
```
