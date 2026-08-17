## Create a 3-replica Deployment

Create a Deployment named `web`:
- image `nginx:1.27`
- `3` replicas
- pod label `app: web` (matching selector, this is automatic)
- container port `80`

```bash
kubectl create deployment web --image=nginx:1.27 --replicas=3 --port=80 --dry-run=client -o yaml > /root/kcna-scratch/web.yaml
kubectl apply -f /root/kcna-scratch/web.yaml
```

Confirm all three layers exist and are healthy:

```bash
kubectl get deploy,rs,pods -l app=web
```
