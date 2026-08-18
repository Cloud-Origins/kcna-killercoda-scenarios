## Route to app1

Write an Ingress named `apps-ingress` with a single rule: path `/app1` (prefix) routes to `app1-svc` port `80`.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: apps-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - path: /app1
            pathType: Prefix
            backend:
              service:
                name: app1-svc
                port:
                  number: 80
```

Apply it, get the ingress controller's external IP/port, and curl `/app1`.

<br>

<details><summary>Tip</summary>

The Ingress controller is fronted by its own Service, not by `apps-ingress` directly. Find its `NodePort`:

```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller
```{{exec}}

</details>

<details><summary>Solution</summary>

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl -s "http://$NODE_IP:$NODE_PORT/app1"
```

Expect the response to include `server address` (the app1 pod answering through the Ingress).

</details>
