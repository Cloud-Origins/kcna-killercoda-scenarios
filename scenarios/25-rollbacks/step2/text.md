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

<br>

<details><summary>Solution</summary>

Deployment `web` should be back on image `nginx:1.26` with `3/3` ready replicas -- `rollout undo` reverted to the last good revision without you ever having to remember or retype the image tag:

```bash
kubectl get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}, {.status.readyReplicas}/{.spec.replicas} ready{"\n"}'
```{{exec}}

</details>
