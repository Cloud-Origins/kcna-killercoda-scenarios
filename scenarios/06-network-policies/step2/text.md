## Fix it

Edit the policy and correct the selector:

```bash
kubectl edit networkpolicy backend-allow-frontend
```

Change `app: frontnd` to `app: frontend` under `spec.ingress[0].from[0].podSelector.matchLabels`. Save, then confirm traffic flows:

```bash
kubectl exec frontend -- wget -qO- --timeout=5 backend-svc
```
