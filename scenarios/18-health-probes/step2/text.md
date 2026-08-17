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

Compare what you see against what you'd expect from a *liveness* failure versus a *readiness* failure -- did the pod restart? Is it still `Running`? Is it still in the Service's endpoint list? That comparison is the whole distinction, in one broken file.
