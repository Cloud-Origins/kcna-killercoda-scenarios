## Expose it externally

Create a second Service, `backend-nodeport`, type `NodePort`, same selector, exposed on node port `30080`:

```bash
kubectl expose deployment backend --name=backend-nodeport --type=NodePort --port=80 --target-port=80
kubectl patch svc backend-nodeport -p '{"spec":{"ports":[{"port":80,"targetPort":80,"nodePort":30080}]}}'
```

Verify it's reachable from outside the pod network, via any node's IP on port `30080`.

<br>

<details><summary>Tip</summary>

Node IPs live on the node objects themselves, not on the Service:

```bash
kubectl get nodes -o wide
```{{exec}}

</details>

<details><summary>Solution</summary>

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl -s -o /dev/null -w "%{http_code}\n" "http://$NODE_IP:30080"
```

Expect `backend-nodeport` to be type `NodePort` with `nodePort: 30080`, and the curl to return HTTP `200`.

</details>
