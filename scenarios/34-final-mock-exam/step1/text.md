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
