## Architecture and container interfaces

Answer each question with a single letter (A/B/C/D). Write all five letters, one per line, to `/root/kcna-scratch/quiz-1.txt` -- for example:

```bash
cat <<'EOF' > /root/kcna-scratch/quiz-1.txt
B
B
C
A
B
EOF
```

(That example is not the answer key -- work out your own answers first.)

**Q1.** Which component is responsible for storing all cluster state?
A) kubelet B) etcd C) kube-proxy D) containerd

**Q2.** Which component implements the Container Runtime Interface (CRI) to actually run containers on a node?
A) kube-scheduler B) containerd C) kube-apiserver D) coredns

**Q3.** Which plugin interface handles Pod networking?
A) CSI B) CRI C) CNI D) CCM

**Q4.** Which plugin interface handles attaching external storage volumes?
A) CSI B) CRI C) CNI D) CCM

**Q5.** Which control-plane component watches for Pods with no assigned node and picks one for them?
A) kubelet B) kube-scheduler C) kube-proxy D) etcd
