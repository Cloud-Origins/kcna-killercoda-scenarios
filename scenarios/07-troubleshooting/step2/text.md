## Fix the service with no endpoints

`webapp` is running now, but the Service still doesn't route to it:

```bash
kubectl get endpoints webapp-svc
```

Empty. A Service with no matching pods has no endpoints -- traffic goes nowhere.

Compare what the Service is looking for against what the pod actually has:

```bash
kubectl get svc webapp-svc -o yaml | grep -A2 selector
kubectl get pod -l app=webapp --show-labels
```

Fix the selector so it matches the pod's real label:

```bash
kubectl edit svc webapp-svc
```

<br>

<details><summary>Tip</summary>

Diff the two values instead of eyeballing them:

```bash
diff <(kubectl get svc webapp-svc -o jsonpath='{.spec.selector.app}') <(kubectl get pod -l app=webapp -o jsonpath='{.items[0].metadata.labels.app}')
```{{exec}}

</details>

<details><summary>Solution</summary>

The Service selects `app: web-app`, but the pod is labeled `app: webapp`. Fix the selector to match:

```bash
kubectl patch svc webapp-svc -p '{"spec":{"selector":{"app":"webapp"}}}'
```

Expect `kubectl get endpoints webapp-svc` to now show the pod's IP, and a request through `webapp-svc` to succeed.

</details>
