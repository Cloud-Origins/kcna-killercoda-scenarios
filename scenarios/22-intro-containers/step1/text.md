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

<br>

<details><summary>Tip</summary>

This is a 2-node environment -- Killercoda gives you a terminal tab per node. The `NODE` column from `kubectl get pod runtime-demo -o wide` tells you which tab to work in; `crictl` only ever sees containers scheduled on the node it's running on, so running it on the wrong node just gives you an empty list, not an error.

</details>

<details><summary>Solution</summary>

`/root/kcna-scratch/answer-image.txt` should contain an image reference that includes `nginx` and `1.27` -- the exact image the Pod was created with:

```bash
kubectl get pod runtime-demo -o wide
```{{exec}}

Then, on the node shown in that `NODE` column:

```bash
CID=$(sudo crictl ps --name runtime-demo -q)
sudo crictl inspect "$CID" -o go-template --template '{{.status.image.image}}' | tee /root/kcna-scratch/answer-image.txt
```

</details>
