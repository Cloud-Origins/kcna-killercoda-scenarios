## Create a ConfigMap and a Secret

Create a ConfigMap named `app-config` with key `APP_MODE=production`:

```bash
kubectl create configmap app-config --from-literal=APP_MODE=production
```

Create a Secret named `app-secret` (type Opaque) with key `API_KEY=s3cr3t`:

```bash
kubectl create secret generic app-secret --from-literal=API_KEY=s3cr3t
```

Confirm both exist:

```bash
kubectl get configmap app-config -o yaml
kubectl get secret app-secret -o yaml
```

Notice the Secret's value is base64-encoded, not encrypted -- that's an encoding, not a security boundary. Access control (RBAC) is what actually protects it.

<br>

<details><summary>Solution</summary>

- ConfigMap `app-config`: `data.APP_MODE` is `production`
- Secret `app-secret`: `type` is `Opaque`, `data.API_KEY` is the base64 string `czNjcjN0` (which decodes to `s3cr3t`)

</details>
