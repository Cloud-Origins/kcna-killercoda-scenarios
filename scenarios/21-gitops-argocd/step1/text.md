## Declare and sync an Application

Declare an Application against ArgoCD's own well-known example repo (`argoproj/argocd-example-apps`, path `guestbook`), with automated sync and self-heal turned on from the start:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
    syncOptions:
      - CreateNamespace=true
```

Save as `/root/kcna-scratch/application.yaml`, apply it, and watch ArgoCD pull, render, and apply the manifests on its own -- no `kubectl apply` on your part for the guestbook resources themselves:

```bash
kubectl -n argocd get application guestbook -w
```

Wait for `SYNC STATUS` to reach `Synced` and `HEALTH STATUS` to reach `Healthy`.

<br>

<details><summary>Solution</summary>

`kubectl -n argocd get application guestbook` should show `SYNC STATUS: Synced` and `HEALTH STATUS: Healthy`, and there should be at least one Deployment actually created in the `guestbook` namespace -- proof ArgoCD applied the manifests, not just recorded intent:

```bash
kubectl -n argocd get application guestbook -o jsonpath='{.status.sync.status} {.status.health.status}{"\n"}'
```{{exec}}

```bash
kubectl -n guestbook get deploy
```{{exec}}

</details>
