## Create an under-provisioned Deployment and a VPA

Create a Deployment named `sized-app` that requests way less CPU (`10m`) than it actually needs -- it runs a real busy loop, not a sleep:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sized-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sized-app
  template:
    metadata:
      labels:
        app: sized-app
    spec:
      containers:
        - name: sized-app
          image: busybox:1.36
          command: ["sh", "-c", "while true; do :; done"]
          resources:
            requests:
              cpu: "10m"
              memory: "10Mi"
            limits:
              cpu: "500m"
              memory: "50Mi"
---
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: sized-app
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: sized-app
  updatePolicy:
    updateMode: "Auto"
```

Save as `/root/kcna-scratch/vpa.yaml`, apply, and watch the recommender build a picture of real usage:

```bash
kubectl describe vpa sized-app
```
