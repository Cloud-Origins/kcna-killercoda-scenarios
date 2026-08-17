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
