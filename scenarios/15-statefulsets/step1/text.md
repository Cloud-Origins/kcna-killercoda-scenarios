## Create a headless Service and a StatefulSet

Create a headless Service named `data` (`clusterIP: None`, selector `app: data`, port `80`) and a StatefulSet named `data` (2 replicas, `serviceName: data`, image `nginx:1.27`, pod label `app: data`, a `volumeClaimTemplate` named `www` requesting `1Gi`). Pin pods to the storage node with `nodeSelector`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: data
spec:
  clusterIP: None
  selector:
    app: data
  ports:
    - port: 80
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: data
spec:
  serviceName: data
  replicas: 2
  selector:
    matchLabels:
      app: data
  template:
    metadata:
      labels:
        app: data
    spec:
      nodeSelector:
        kcna-storage: "true"
      containers:
        - name: data
          image: nginx:1.27
          volumeMounts:
            - name: www
              mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
    - metadata:
        name: www
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: manual
        resources:
          requests:
            storage: 1Gi
```

Save as `/root/kcna-scratch/statefulset.yaml`, apply it, then confirm ordered names and one PVC per pod:

```bash
kubectl get sts,pods,pvc
```
