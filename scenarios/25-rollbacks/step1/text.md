## Ship a broken release and watch it stall

Ship an image tag that doesn't exist -- the kind of typo that gets past code review:

```bash
kubectl set image deployment/web web=nginx:1.27-typo-does-not-exist
```

Watch the rollout not finish:

```bash
kubectl rollout status deployment/web --timeout=30s || true
kubectl get pods -l app=web
kubectl describe pod -l app=web | grep -A3 -i "Events:"
```

The old `nginx:1.26` pods are still there and still serving -- the rolling update strategy from the last scenario means a broken new pod never gets to replace a working old one. Confirm the Deployment is not fully progressed:

```bash
kubectl rollout status deployment/web --timeout=5s || echo "confirmed: not progressing" > /root/kcna-scratch/answer-stalled.txt
```

<br>

<details><summary>Solution</summary>

At least one `web` Pod should be stuck with an `ImagePull`/`ErrImage` reason on the bad tag, while at least one `nginx:1.26` Pod should still show `Ready`:

```bash
kubectl get pods -l app=web -o jsonpath='{range .items[*]}{.spec.containers[0].image}{" "}{.status.containerStatuses[0].ready}{" "}{.status.containerStatuses[0].state.waiting.reason}{"\n"}{end}'
```{{exec}}

</details>
