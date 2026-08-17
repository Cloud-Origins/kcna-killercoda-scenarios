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
