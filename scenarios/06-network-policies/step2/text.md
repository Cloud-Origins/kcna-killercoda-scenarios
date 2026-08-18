## Fix it

Edit the policy and correct the selector:

```bash
kubectl edit networkpolicy backend-allow-frontend
```

Change `app: frontnd` to `app: frontend` under `spec.ingress[0].from[0].podSelector.matchLabels`. Save, then confirm traffic flows:

```bash
kubectl exec frontend -- wget -qO- --timeout=5 backend-svc
```

<br>

<details><summary>Solution</summary>

`backend-allow-frontend`'s `spec.ingress[0].from[0].podSelector.matchLabels.app` should read `frontend`, and the `wget` from `frontend` to `backend-svc` should succeed instead of timing out.

```bash
kubectl get networkpolicy backend-allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}'
```{{exec}}

</details>
