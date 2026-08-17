## ConfigMaps & Secrets

Configuration and sensitive values don't belong baked into an image. This scenario externalizes both and proves they actually reach the container as environment variables.

**You will:**
1. Create a ConfigMap and a Secret
2. Wire both into a Pod as env vars and confirm with `printenv`

**Target time:** 45 minutes
