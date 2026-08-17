## Serverless: Knative Scale-to-Zero

Knative Serving and the lightweight Kourier networking layer are already installed -- no Istio, kept minimal for boot time. This is the property plain Deployments don't have: idle workloads that cost nothing to run because there's genuinely nothing running.

**You will:**
1. Deploy a Knative Service and reach it through Kourier, no DNS involved
2. Go idle and watch the pod count actually drop to zero

**Target time:** 55 minutes
