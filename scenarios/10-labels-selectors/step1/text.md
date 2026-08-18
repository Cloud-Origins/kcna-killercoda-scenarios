## Create three labeled Pods

Create three Pods, all image `nginx:1.27`:

| Pod name | Labels |
|---|---|
| `shop-prod` | `app: shop`, `env: prod` |
| `shop-dev` | `app: shop`, `env: dev` |
| `api-prod` | `app: api`, `env: prod` |

Fastest way, one command each:

```bash
kubectl run shop-prod --image=nginx:1.27 --labels=app=shop,env=prod
kubectl run shop-dev --image=nginx:1.27 --labels=app=shop,env=dev
kubectl run api-prod --image=nginx:1.27 --labels=app=api,env=prod
```

Confirm:

```bash
kubectl get pods --show-labels
```

<br>

<details><summary>Solution</summary>

`kubectl get pods --show-labels` should show all three Pods Running with these labels:

| Pod | Labels |
|---|---|
| `shop-prod` | `app=shop,env=prod` |
| `shop-dev` | `app=shop,env=dev` |
| `api-prod` | `app=api,env=prod` |

</details>
