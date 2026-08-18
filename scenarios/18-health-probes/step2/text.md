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

<br>

<details><summary>Solution</summary>

`kubectl get pod "$POD"` should still show `Running` with `0` restarts -- the TCP liveness probe only checks that port `80` is listening, and it still is, so liveness never fires. `kubectl get endpoints web-svc` should now list only 1 IP address: the broken Pod's IP is gone, because the HTTP readiness probe on `/` fails once `index.html` is missing. Same Pod, same restart count, just pulled out of the Service.

</details>
