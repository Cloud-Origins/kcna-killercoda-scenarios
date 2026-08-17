## Upgrade a value, then roll back

Bump the replica count and upgrade in place:

```bash
helm upgrade webapp mychart --set replicaCount=3
```

Confirm the upgrade landed:

```bash
helm history webapp
kubectl get deploy -l app.kubernetes.io/instance=webapp
```

Now roll back to the revision before the upgrade:

```bash
helm rollback webapp 1
```

Confirm you're back to 2 replicas, and that history shows the full story -- install, upgrade, rollback:

```bash
helm history webapp
```
