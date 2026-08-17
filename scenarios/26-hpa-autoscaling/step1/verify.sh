#!/bin/bash
set -e

TARGET=$(kubectl get hpa cpu-app -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}' 2>/dev/null || echo "")
if [ "$TARGET" != "50" ]; then
  echo "HPA 'cpu-app' target CPU utilization is '$TARGET', expected 50."
  exit 1
fi

MAX=$(kubectl get hpa cpu-app -o jsonpath='{.spec.maxReplicas}' 2>/dev/null || echo "")
if [ "$MAX" != "4" ]; then
  echo "HPA 'cpu-app' maxReplicas is '$MAX', expected 4."
  exit 1
fi

CURRENT_UTIL=$(kubectl get hpa cpu-app -o jsonpath='{.status.currentMetrics[0].resource.current.averageUtilization}' 2>/dev/null || echo "")
if [ -z "$CURRENT_UTIL" ]; then
  echo "HPA 'cpu-app' is not reporting a real CPU percentage yet -- metrics-server may still be scraping. Wait and check again."
  exit 1
fi

echo "HPA 'cpu-app' created and receiving real metrics ($CURRENT_UTIL% CPU)."
exit 0
