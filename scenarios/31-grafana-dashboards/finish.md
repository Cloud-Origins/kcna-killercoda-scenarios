## Done

A Grafana panel is a saved PromQL query plus rendering instructions -- nothing more. `POST /api/dashboards/db` is the same call the UI makes when you click Save; `/api/datasources/proxy/{id}/...` is the same call a panel makes when it refreshes. Provisioning both as code (the datasource in `background.sh`, the dashboard through the API) is exactly how this is done in a real GitOps-managed observability stack, not clicked together by hand and screenshotted.

This is the KCNA **Dashboards and visualization** competency under Cloud Native Observability.

**Next: Level 32, OpenTelemetry Traces.**
