## OpenTelemetry Traces

Jaeger is already running with its OTLP receiver enabled. Distributed tracing's whole point is following one request across service boundaries -- this scenario sends one real trace over the wire in the real OTLP wire format, and queries it back out, without a full instrumented microservice demo getting in the way of the core mechanism.

**You will:**
1. Hand-craft and send a real OTLP/HTTP trace payload to Jaeger
2. Query it back out of Jaeger's API to prove the pipeline actually stored it

**Target time:** 50 minutes
