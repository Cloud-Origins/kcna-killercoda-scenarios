## Roll the image while traffic keeps flowing

Launch a monitor pod that hammers `web-svc` continuously and counts failures:

```bash
kubectl run traffic-monitor --image=busybox:1.36 --restart=Never --command -- sh -c '
i=0; fails=0
while [ $i -lt 200 ]; do
  wget -qO- -T 2 http://web-svc >/dev/null 2>&1 || fails=$((fails+1))
  i=$((i+1))
  echo $fails > /tmp/fail-count.txt
  sleep 0.3
done
sleep 3600
'
kubectl wait --for=condition=Ready pod/traffic-monitor --timeout=30s
```

While it's running (about a minute of requests), trigger the rollout:

```bash
kubectl set image deployment/web web=nginx:1.27
kubectl rollout status deployment/web --timeout=90s
```

Give the monitor a few more seconds to finish its 200 requests, then check the damage:

```bash
sleep 15
kubectl exec traffic-monitor -- cat /tmp/fail-count.txt
```
