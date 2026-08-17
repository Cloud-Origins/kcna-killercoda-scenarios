## Done

Helm's real value isn't templating -- it's the release history. Every `install`/`upgrade` is a numbered revision, and `rollback` isn't "undo my last edit," it's "redeploy the exact rendered manifests from revision N." That's what makes upgrades low-risk in production: the previous known-good state is always one command away.

This is the KCNA **Helm** competency under Cloud Native Application Delivery.

**Next: Level 20, Monitoring: Prometheus & Grafana.**
