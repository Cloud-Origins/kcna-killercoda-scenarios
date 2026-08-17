## Expose it internally

The `backend` Deployment labels its pods `app: backend`. Create a ClusterIP Service named `backend-svc` that selects those pods and forwards port `80`:

```bash
kubectl expose deployment backend --name=backend-svc --port=80 --target-port=80
```

(Or write the Service manifest by hand if you'd rather practice the YAML.)

Confirm it resolves and routes:

```bash
kubectl run test-client --rm -it --image=busybox --restart=Never -- wget -qO- backend-svc
```
