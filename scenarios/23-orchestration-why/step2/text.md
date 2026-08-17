## Let a controller do it, then kill one -- and it comes back

Same "three copies of nginx" requirement, this time as a Deployment:

```bash
kubectl create deployment controlled --image=nginx:1.27 --replicas=3
kubectl wait --for=condition=Available deployment/controlled --timeout=60s
kubectl get pods -l app=controlled
```

Kill one Pod, exactly the same action as step 1:

```bash
POD=$(kubectl get pods -l app=controlled -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod "$POD"
sleep 5
kubectl get pods -l app=controlled
```

Compare this pod list against step 1's -- same delete action, same starting count. Whatever difference you see (or don't) between "manual" and "controlled" is the ReplicaSet's reconcile loop either doing its job, or not. That loop is the entire value proposition of an orchestrator.
