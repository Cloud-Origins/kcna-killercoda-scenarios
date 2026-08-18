## Create a Deployment with liveness and readiness probes

Create a Deployment named `web` (image `nginx:1.27`, 2 replicas, label `app: web`) with:
- a `livenessProbe`: TCP socket check on port `80`, `initialDelaySeconds: 5`, `periodSeconds: 10`
- a `readinessProbe`: HTTP GET `/` on port `80`, `initialDelaySeconds: 5`, `periodSeconds: 5`

TCP for liveness on purpose -- it only asks "is something listening," so it won't fail just because the content is broken. That distinction matters in step 2.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 2
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
          image: nginx:1.27
          ports:
            - containerPort: 80
          livenessProbe:
            tcpSocket:
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
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

Save as `/root/kcna-scratch/probes.yaml`, apply, and confirm:

```bash
kubectl get deploy web
kubectl get endpoints web-svc
```

<br>

<details><summary>Solution</summary>

`kubectl get deploy web` should show `2/2` ready replicas. `kubectl get endpoints web-svc` should list 2 IP addresses -- both readiness probes passing, so both Pods are in the Service.

</details>
