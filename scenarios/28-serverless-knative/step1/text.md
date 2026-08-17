## Deploy a Knative Service and reach it through Kourier

Create a Knative `Service` -- not a plain Kubernetes Deployment -- named `hello`:

```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: hello
  namespace: default
spec:
  template:
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go
          env:
            - name: TARGET
              value: "KCNA"
```

Save as `/root/kcna-scratch/hello.yaml`, apply, and wait for it to become Ready:

```bash
kubectl wait --for=condition=Ready ksvc/hello --timeout=120s
kubectl get pods -l serving.knative.dev/service=hello
```

There's no DNS set up in this sandbox, so reach it the way any load balancer would -- through Kourier's ClusterIP with the right `Host` header, from inside the cluster:

```bash
HOST=$(kubectl get ksvc hello -o jsonpath='{.status.url}' | sed 's|http://||')
KOURIER_IP=$(kubectl -n kourier-system get svc kourier -o jsonpath='{.spec.clusterIP}')
kubectl run curler --image=busybox:1.36 --restart=Never --rm -i --command -- \
  wget -qO- --header "Host: $HOST" "http://$KOURIER_IP"
```

A real response should come back, not a connection error -- and it should reflect the `TARGET` value you set in the manifest above, not some generic default.
