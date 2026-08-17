## Drift the cluster and watch ArgoCD self-heal

Save the replica count Git actually declares, before you touch anything:

```bash
kubectl -n guestbook get deploy guestbook-ui -o jsonpath='{.spec.replicas}' > /root/kcna-scratch/original-replicas.txt
cat /root/kcna-scratch/original-replicas.txt
```

Now drift it -- scale the Deployment directly with `kubectl`, bypassing Git entirely, the way a "quick fix at 2am" always starts:

```bash
kubectl -n guestbook scale deployment guestbook-ui --replicas=5
```

With a normal Deployment this would just stick. With `selfHeal: true`, ArgoCD notices the live state no longer matches Git and reverts it -- watch it happen:

```bash
sleep 15
kubectl -n guestbook get deploy guestbook-ui
kubectl -n argocd get application guestbook -o jsonpath='{.status.sync.status}{"\n"}'
```
