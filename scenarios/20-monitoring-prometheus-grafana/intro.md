## Monitoring: Prometheus & Grafana

The full `kube-prometheus-stack` (Operator, Alertmanager, Grafana, node-exporter, kube-state-metrics) is the production-realistic choice, but it's too heavy to boot reliably in under an hour on a small sandbox. This scenario installs the leaner `prometheus` chart -- same scrape-and-store engine, same PromQL, without the extra weight -- and proves it's actually collecting metrics, not just running.

**You will:**
1. Install Prometheus (server + node-exporter + kube-state-metrics) with Helm
2. Query the Prometheus HTTP API directly and confirm real scrape targets are up

**Target time:** 55 minutes
