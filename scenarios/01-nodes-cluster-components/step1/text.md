## Find the control plane

List the nodes:

```bash
kubectl get nodes
```

Inspect what's running in the `kube-system` namespace, and figure out which node hosts the control plane components (`etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`):

```bash
kubectl get pods -n kube-system -o wide
```

Write the **name of the control plane node** to `/root/kcna-scratch/answer-controlplane.txt`:

```bash
echo "<node-name>" > /root/kcna-scratch/answer-controlplane.txt
```

<br>

<details><summary>Tip</summary>

Every control-plane node carries a well-known label. You don't have to eyeball the pod list at all:

```plain
kubectl get nodes -l node-role.kubernetes.io/control-plane
```{{exec}}

</details>

<details><summary>Solution</summary>

```plain
kubectl get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}' > /root/kcna-scratch/answer-controlplane.txt
```{{exec}}

</details>
