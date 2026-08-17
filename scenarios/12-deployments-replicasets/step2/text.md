## Prove self-healing, then scale

Capture the current Pod names before breaking anything:

```bash
kubectl get pods -l app=web -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > /root/kcna-scratch/pods-before.txt
```

Delete one Pod directly:

```bash
kubectl delete pod $(kubectl get pods -l app=web -o jsonpath='{.items[0].metadata.name}')
```

Wait for the ReplicaSet to replace it, then capture the new Pod names:

```bash
sleep 5
kubectl wait --for=condition=Ready pods -l app=web --timeout=60s
kubectl get pods -l app=web -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort > /root/kcna-scratch/pods-after.txt
```

Compare `pods-before.txt` and `pods-after.txt` -- same count, different name in the set. That's the ReplicaSet doing its job, not you.

Now scale up:

```bash
kubectl scale deployment web --replicas=5
kubectl wait --for=condition=Ready pods -l app=web --timeout=60s
```
