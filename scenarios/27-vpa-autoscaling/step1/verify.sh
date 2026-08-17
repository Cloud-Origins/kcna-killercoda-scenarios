#!/bin/bash
set -e

MODE=$(kubectl get vpa sized-app -o jsonpath='{.spec.updatePolicy.updateMode}' 2>/dev/null || echo "")
if [ "$MODE" != "Auto" ]; then
  echo "VPA 'sized-app' updateMode is '$MODE', expected 'Auto'."
  exit 1
fi

REQUEST=$(kubectl get deploy sized-app -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null || echo "")
if [ "$REQUEST" != "10m" ]; then
  echo "Deployment 'sized-app' cpu request is '$REQUEST', expected the deliberately low '10m'."
  exit 1
fi

RECOMMENDATION=$(kubectl get vpa sized-app -o jsonpath='{.status.recommendation.containerRecommendations[0].target.cpu}' 2>/dev/null || echo "")
if [ -z "$RECOMMENDATION" ]; then
  echo "VPA 'sized-app' has no recommendation yet -- the recommender needs a little more time to observe real usage."
  exit 1
fi

echo "VPA 'sized-app' is live and recommending $RECOMMENDATION cpu (vs the 10m request)."
exit 0
