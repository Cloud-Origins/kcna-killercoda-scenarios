## Fix the pod that won't start

```bash
kubectl get pods
```

It's not `Running`. Find out why:

```bash
kubectl describe pod -l app=webapp
```

Fix the root cause directly in the cluster (edit the Deployment, don't just delete and hope):

```bash
kubectl edit deployment webapp
```

<br>

<details><summary>Tip</summary>

`describe` names the failure reason directly -- look for `ImagePullBackOff` or `ErrImagePull` in the Events section, then check what image/tag it's actually trying to pull:

```bash
kubectl get pod -l app=webapp -o jsonpath='{.items[0].spec.containers[0].image}'
```{{exec}}

</details>

<details><summary>Solution</summary>

The image tag is wrong (it doesn't exist in the registry). Point the container at a tag that does:

```bash
kubectl set image deployment/webapp webapp=nginxdemos/hello:plain-text
kubectl rollout status deployment/webapp
```

</details>
