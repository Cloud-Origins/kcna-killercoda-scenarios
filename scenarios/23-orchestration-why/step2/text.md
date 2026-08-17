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

Three again -- a different name where `$POD` used to be, but three. The ReplicaSet's reconcile loop noticed the gap and closed it, unprompted. That loop is the entire value proposition of an orchestrator.
