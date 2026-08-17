## Done

That's the entire pitch for pull-based GitOps in one drift-and-revert: the cluster isn't the source of truth, Git is, and `kubectl scale` against a self-healing Application is a temporary illusion, not a real change. This is also why GitOps closes the loop that a plain CI/CD push pipeline leaves open -- manual `kubectl` drift in production gets silently and automatically corrected instead of accumulating unnoticed.

This is the KCNA/CKAD **GitOps** competency under Cloud Native Application Delivery -- a bonus level, since ArgoCD sits in the CKAD track by program design, not core KCNA.

**That's all 21 levels. KCNA exam prep track complete.**
