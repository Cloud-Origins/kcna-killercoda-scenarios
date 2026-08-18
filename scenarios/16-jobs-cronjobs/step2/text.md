## Create a CronJob and watch it fire

Create a CronJob named `hello`:
- schedule `*/1 * * * *` (every minute -- compressed from the usual `*/5` so you don't wait 5 minutes to see it work)
- image `busybox:1.36`, command `sh -c "date; echo hello"`
- `restartPolicy: OnFailure`

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: hello
              image: busybox:1.36
              command: ["sh", "-c", "date; echo hello"]
```

Save as `/root/kcna-scratch/cronjob.yaml`, apply it, then wait for the clock to tick over and check:

```bash
kubectl get cronjob hello
kubectl get jobs --watch
```

Once you see a Job spawned from `hello` (name like `hello-28...`), check its logs:

```bash
JOB=$(kubectl get jobs --no-headers -o custom-columns=NAME:.metadata.name | grep ^hello- | head -1)
kubectl logs job/$JOB
```

<br>

<details><summary>Solution</summary>

`kubectl get cronjob hello` should show schedule `*/1 * * * *`. Once a minute ticks over, `kubectl get jobs` should show a Job named `hello-<timestamp>`, and its logs should contain the date output followed by `hello`.

</details>
