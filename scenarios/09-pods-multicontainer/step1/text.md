## Create a single-container Pod

Create a Pod named `web`:
- image `nginx:1.27`
- label `app: web`
- container port `80`

The imperative form gets you a manifest fast:

```bash
kubectl run web --image=nginx:1.27 --port=80 --labels=app=web --dry-run=client -o yaml > /root/kcna-scratch/web.yaml
kubectl apply -f /root/kcna-scratch/web.yaml
```

Confirm it's running:

```bash
kubectl get pod web -o wide
```

<br>

<details><summary>Solution</summary>

Pod `web` should show image `nginx:1.27`, label `app=web`, `containerPort` `80`, and phase `Running`:

```bash
kubectl get pod web -o jsonpath='{.spec.containers[0].image} {.metadata.labels.app} {.spec.containers[0].ports[0].containerPort} {.status.phase}{"\n"}'
```{{exec}}

</details>
