## Read a crashed container's logs with --previous

`crasher` has already restarted once. Check current logs first:

```bash
kubectl logs crasher
```

That shows the container running *now* -- it won't mention why it crashed the first time, because that instance is gone. Get the previous instance's logs instead:

```bash
kubectl logs crasher --previous
```

Save the crash reason from the previous instance's logs:

```bash
kubectl logs crasher --previous > /root/kcna-scratch/answer-previous-log.txt
cat /root/kcna-scratch/answer-previous-log.txt
```
