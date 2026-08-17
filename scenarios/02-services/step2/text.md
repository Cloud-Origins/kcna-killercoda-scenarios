## Expose it externally

Create a second Service, `backend-nodeport`, type `NodePort`, same selector, exposed on node port `30080`:

```bash
kubectl expose deployment backend --name=backend-nodeport --type=NodePort --port=80 --target-port=80
kubectl patch svc backend-nodeport -p '{"spec":{"ports":[{"port":80,"targetPort":80,"nodePort":30080}]}}'
```

Verify it's reachable from outside the pod network, via any node's IP on port `30080`.
