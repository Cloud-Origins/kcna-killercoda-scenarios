## Done

A trace is nothing more exotic than a `traceId` shared by every span involved in one request, each span timestamped and named. An SDK usually generates the ID and wraps `startTimeUnixNano`/`endTimeUnixNano` around your code automatically -- you just did the same thing by hand, over the same OTLP wire format, into the same receiver a real collector uses. Distributed tracing across services works because every hop propagates that one `traceId` forward; this scenario was the single-hop version of that same mechanism.

This is the KCNA **Distributed tracing** competency under Cloud Native Observability.

**Next: Level 33, Tekton CI/CD.**
