## Add path-based routing to app2

Edit `apps-ingress` and add a second path rule: `/app2` (prefix) routes to `app2-svc` port `80`. Same Ingress object, two paths.

```bash
kubectl edit ingress apps-ingress
```

Add under `spec.rules[0].http.paths`:

```yaml
          - path: /app2
            pathType: Prefix
            backend:
              service:
                name: app2-svc
                port:
                  number: 80
```

<br>

<details><summary>Solution</summary>

`apps-ingress` should have both paths on `spec.rules[0].http.paths`: `/app1` -> `app1-svc`, `/app2` -> `app2-svc`. Confirm by curling the new path through the same ingress controller Service as before:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl -s "http://$NODE_IP:$NODE_PORT/app2"
```

Expect `server address` in the response.

</details>
