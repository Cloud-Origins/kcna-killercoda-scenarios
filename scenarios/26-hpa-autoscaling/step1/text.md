## Install metrics-server and create an HPA

`metrics-server` is already up. Create a Deployment named `cpu-app`, deliberately idle at first (low CPU request, near-zero real usage), and an HPA targeting 50% CPU utilization:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cpu-app
  template:
    metadata:
      labels:
        app: cpu-app
    spec:
      containers:
        - name: cpu-app
          image: busybox:1.36
          command: ["sh", "-c", "while true; do sleep 5; done"]
          resources:
            requests:
              cpu: "50m"
            limits:
              cpu: "500m"
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cpu-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: cpu-app
  minReplicas: 1
  maxReplicas: 4
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

Save as `/root/kcna-scratch/hpa.yaml`, apply, and wait for metrics-server to actually report a number (not `<unknown>`):

```bash
kubectl get hpa cpu-app -w
```

<br>

<details><summary>Solution</summary>

Once metrics-server has scraped at least once, `kubectl get hpa cpu-app` should show:

- `TARGETS` column with a real percentage like `1%/50%` (not `<unknown>/50%`)
- `MAXPODS` = `4`
- `REPLICAS` = `1` (still idle, hasn't scaled yet)

If you want to confirm the raw fields instead of eyeballing the table:

```bash
kubectl get hpa cpu-app -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}{"\n"}{.spec.maxReplicas}{"\n"}{.status.currentMetrics[0].resource.current.averageUtilization}{"\n"}'
```{{exec}}

Expect `50`, `4`, and a numeric CPU percentage on the three lines. If the third line is empty, metrics-server hasn't scraped yet -- wait and re-run.

</details>
