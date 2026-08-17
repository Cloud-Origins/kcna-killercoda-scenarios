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
