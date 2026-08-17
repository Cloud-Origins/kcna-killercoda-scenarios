#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

# Pin one node for storage locality so hostPath-backed PVCs survive a
# pod reschedule -- kubeadm-2nodes has no default StorageClass, so
# PVs are pre-staged here rather than dynamically provisioned.
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
kubectl label node "$NODE" kcna-storage=true --overwrite

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: www-data-0
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /mnt/kcna-data/www-data-0
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kcna-storage
              operator: In
              values:
                - "true"
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: www-data-1
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /mnt/kcna-data/www-data-1
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kcna-storage
              operator: In
              values:
                - "true"
EOF

touch /tmp/kcna-background-done
