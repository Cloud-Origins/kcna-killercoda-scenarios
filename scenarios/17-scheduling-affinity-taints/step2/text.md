## Schedule onto the tainted node with affinity and a toleration

Create a Pod named `pinned` (image `nginx:1.27`) that:
- uses `requiredDuringSchedulingIgnoredDuringExecution` node affinity requiring `kubernetes.io/os` In `[linux]`
- tolerates `dedicated=labs:NoSchedule`
- targets the tainted node specifically, so you can prove it actually landed there

```bash
NODE=$(cat /root/kcna-scratch/tainted-node.txt)
cat <<EOF > /root/kcna-scratch/pinned.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pinned
spec:
  nodeSelector:
    kubernetes.io/hostname: $NODE
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: kubernetes.io/os
                operator: In
                values: ["linux"]
  tolerations:
    - key: dedicated
      operator: Equal
      value: labs
      effect: NoSchedule
  containers:
    - name: pinned
      image: nginx:1.27
EOF
kubectl apply -f /root/kcna-scratch/pinned.yaml
```

Confirm it actually scheduled onto the tainted node, unlike `blocked-test`:

```bash
kubectl get pod pinned -o wide
```

<br>

<details><summary>Solution</summary>

`kubectl get pod pinned -o wide` should show it `Running`, with `NODE` matching the value in `/root/kcna-scratch/tainted-node.txt` -- unlike `blocked-test`, the `dedicated=labs:NoSchedule` toleration lets it land on the tainted node.

</details>
