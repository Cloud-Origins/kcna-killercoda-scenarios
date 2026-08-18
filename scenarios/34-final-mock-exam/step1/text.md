## Part A: Diagnose and build

**A1. Fix `mock-svc`.** It has zero endpoints even though `mock-backend` is healthy:

```bash
kubectl get endpoints mock-svc
kubectl get deploy mock-backend -o jsonpath='{.spec.selector.matchLabels}'
kubectl get svc mock-svc -o jsonpath='{.spec.selector}'
```

Compare the two label sets, then fix the Service:

```bash
kubectl edit svc mock-svc
```

**A2. Build `exam-app`.** Create a ConfigMap `exam-config` with key `MODE=production`, and a Deployment `exam-app` (image `nginx:1.27`, 2 replicas, label `app: exam-app`) whose container:
- has an `APP_MODE` env var sourced from `exam-config`'s `MODE` key
- has a `readinessProbe`: HTTP GET `/` on port `80`

```bash
kubectl create configmap exam-config --from-literal=MODE=production
```

Write the Deployment YAML yourself, combining what you built in levels 12, 13, and 18 -- a ConfigMap-sourced env var plus a readiness probe on the same container. Apply it and confirm `2/2` ready.

<br>

<details><summary>Tip</summary>

For A1, don't eyeball the label dump -- diff it programmatically:

```bash
diff <(kubectl get deploy mock-backend -o jsonpath='{.spec.selector.matchLabels}') <(kubectl get svc mock-svc -o jsonpath='{.spec.selector}')
```{{exec}}

</details>

<details><summary>Solution</summary>

**A1.** `mock-svc`'s selector doesn't match `mock-backend`'s real label. Patch it:

```bash
kubectl patch svc mock-svc -p '{"spec":{"selector":{"app":"mock-backend"}}}'
```

`kubectl get endpoints mock-svc` should then list two pod IPs.

**A2.** Deployment combining a ConfigMap-sourced env var and an HTTP readiness probe:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: exam-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: exam-app
  template:
    metadata:
      labels:
        app: exam-app
    spec:
      containers:
        - name: exam-app
          image: nginx:1.27
          ports:
            - containerPort: 80
          env:
            - name: APP_MODE
              valueFrom:
                configMapKeyRef:
                  name: exam-config
                  key: MODE
          readinessProbe:
            httpGet:
              path: /
              port: 80
```

Apply it, then confirm:

```bash
kubectl get deploy exam-app
```{{exec}}

`READY` should show `2/2`.

</details>
