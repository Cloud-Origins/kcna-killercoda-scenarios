## Done

Grafana never collects anything -- it's a query and rendering layer on top of Prometheus's own HTTP API, the exact endpoint you just queried directly. Understanding `up`, scrape targets, and PromQL at the API level is what actually gets tested on KCNA; the dashboard is presentation on top of that.

This is the KCNA **Cloud Native Observability** domain, monitoring with Prometheus.

**Next: Level 21, GitOps: ArgoCD Sync & Self-Heal.**
