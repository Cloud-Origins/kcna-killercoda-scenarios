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
