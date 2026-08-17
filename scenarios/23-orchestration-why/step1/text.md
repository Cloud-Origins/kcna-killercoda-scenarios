## Manually scale, then kill one -- and it stays dead

"Manual scaling" means exactly this -- three standalone Pods, each one your responsibility, none of them owned by anything:

```bash
kubectl run manual-1 --image=nginx:1.27 --restart=Never
kubectl run manual-2 --image=nginx:1.27 --restart=Never
kubectl run manual-3 --image=nginx:1.27 --restart=Never
kubectl wait --for=condition=Ready pod -l 'run in (manual-1,manual-2,manual-3)' --timeout=60s
kubectl get pods -l 'run in (manual-1,manual-2,manual-3)'
```

Now kill one, the way a node failure or an OOM kill would:

```bash
kubectl delete pod manual-2
sleep 5
kubectl get pods -l 'run in (manual-1,manual-2,manual-3)'
```

Nothing replaces it. Nothing is watching. That's the whole problem orchestration exists to solve -- write down how many pods survived to `/root/kcna-scratch/answer-manual-count.txt`:

```bash
kubectl get pods -l 'run in (manual-1,manual-2,manual-3)' --no-headers | wc -l > /root/kcna-scratch/answer-manual-count.txt
```
