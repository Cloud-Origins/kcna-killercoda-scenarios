## Undo the rollout

Check the revision history first:

```bash
kubectl rollout history deployment/web
```

Undo back to the previous revision -- no YAML edit, no re-specifying the image:

```bash
kubectl rollout undo deployment/web
kubectl rollout status deployment/web --timeout=60s
```

Confirm you're back on the known-good image with all replicas ready:

```bash
kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
kubectl get pods -l app=web
```
