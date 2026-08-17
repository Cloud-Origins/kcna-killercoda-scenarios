## Consume both as env vars in a Pod

Create a Pod named `configured` (image `nginx:1.27`) with two env vars:
- `APP_MODE` from the ConfigMap key `APP_MODE`
- `API_KEY` from the Secret key `API_KEY`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configured
spec:
  containers:
    - name: app
      image: nginx:1.27
      env:
        - name: APP_MODE
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_MODE
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: API_KEY
```

Save that to `/root/kcna-scratch/configured.yaml`, apply it, then prove the values actually landed inside the container -- not just in the manifest:

```bash
kubectl exec configured -- printenv APP_MODE API_KEY
```
