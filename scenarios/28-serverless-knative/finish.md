## Done

A Knative Service isn't a Deployment with extra steps -- it's a Deployment plus an activator that can hold incoming requests while a scaled-to-zero revision cold-starts a pod on demand, plus an autoscaler (KPA) constantly deciding the target replica count from real request concurrency, down to and including zero. That's the actual mechanism behind "serverless on Kubernetes," not a marketing label on a regular workload.

This is the KCNA **Serverless** competency under Cloud Native Architecture.

**Next: Level 29, CNCF Landscape Quiz.**
