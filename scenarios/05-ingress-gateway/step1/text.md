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
