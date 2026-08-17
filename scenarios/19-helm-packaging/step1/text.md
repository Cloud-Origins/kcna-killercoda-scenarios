## Scaffold and install a chart

Scaffold a new chart:

```bash
cd /root/kcna-scratch
helm create mychart
```

Parameterize the image and replica count in `mychart/values.yaml`:

```bash
sed -i 's/repository: nginx/repository: nginx/' mychart/values.yaml
sed -i 's/tag: ""/tag: "1.27"/' mychart/values.yaml
sed -i 's/replicaCount: 1/replicaCount: 2/' mychart/values.yaml
```

Install it as a release named `webapp`:

```bash
helm install webapp mychart
```

Confirm it deployed with the values you set:

```bash
helm status webapp
kubectl get deploy -l app.kubernetes.io/instance=webapp
```
