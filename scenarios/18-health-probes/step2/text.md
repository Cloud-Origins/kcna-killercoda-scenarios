## Break readiness only and prove the distinction

Pick one pod and save its name:

```bash
kubectl get pods -l app=web -o jsonpath='{.items[0].metadata.name}' > /root/kcna-scratch/target-pod.txt
POD=$(cat /root/kcna-scratch/target-pod.txt)
```

Break its readiness probe by removing the file it serves at `/` -- the TCP port stays open, so this does **not** touch liveness:

```bash
kubectl exec "$POD" -- mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak
```

Wait for the readiness probe to notice, then check:

```bash
sleep 10
kubectl get pod "$POD"
kubectl get endpoints web-svc
```

The pod should still show `Running` with `0` restarts -- liveness never fired -- but `READY` drops to `0/1` and it disappears from `web-svc`'s endpoints. That's the whole distinction in one broken file.
