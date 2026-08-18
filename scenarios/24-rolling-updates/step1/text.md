## Create a Deployment tuned for zero-downtime rollout

Create a Deployment named `web`, image `nginx:1.26`, 4 replicas, with the three things that actually make a rollout zero-downtime -- a readiness probe (so traffic never reaches a not-yet-ready pod), `maxUnavailable: 0` (never drop below 4 ready pods), and a `preStop` hook (gives kube-proxy time to remove the pod's endpoint before it actually stops):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 4
  strategy:
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: nginx:1.26
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 2
            initialDelaySeconds: 2
          lifecycle:
            preStop:
              exec:
                command: ["sh", "-c", "sleep 3"]
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web
  ports:
    - port: 80
```

Save as `/root/kcna-scratch/web.yaml`, apply, and confirm all 4 are ready:

```bash
kubectl rollout status deployment/web --timeout=90s
```

<br>

<details><summary>Solution</summary>

Deployment `web` should have `4/4` ready replicas on image `nginx:1.26`, with `spec.strategy.rollingUpdate.maxUnavailable` set to `0`, and Service `web-svc` should show `4` ready endpoints -- confirming the pods are not just running but actually reachable through the Service:

```bash
kubectl get deploy web -o jsonpath='{.status.readyReplicas}/{.spec.replicas} ready, image={.spec.template.spec.containers[0].image}, maxUnavailable={.spec.strategy.rollingUpdate.maxUnavailable}{"\n"}'
```{{exec}}

</details>
