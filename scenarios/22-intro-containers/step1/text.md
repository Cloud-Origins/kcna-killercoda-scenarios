## Find a container at the runtime layer

`crictl` needs to run on whichever node the pod actually landed on -- check, then SSH or run there if it's not the control-plane node:

```bash
kubectl get pod runtime-demo -o wide
```

If `crictl ps` below comes back empty, you're on the wrong node -- switch to the other one.

On that node, list containers the runtime knows about (not Pods -- containers):

```bash
sudo crictl ps
```

Find the one belonging to `runtime-demo`, then inspect it directly through the runtime -- no `kubectl` involved:

```bash
CID=$(sudo crictl ps --name runtime-demo -q)
sudo crictl inspect "$CID" | grep -i image
```

Save the exact image reference `crictl` reports, using its template output instead of `kubectl`:

```bash
sudo crictl inspect "$CID" -o go-template --template '{{.status.image.image}}' > /root/kcna-scratch/answer-image.txt
cat /root/kcna-scratch/answer-image.txt
```
