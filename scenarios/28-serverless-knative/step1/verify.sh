#!/bin/bash
set -e

READY=$(kubectl get ksvc hello -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "")
if [ "$READY" != "True" ]; then
  echo "Knative Service 'hello' is not Ready yet."
  exit 1
fi

HOST=$(kubectl get ksvc hello -o jsonpath='{.status.url}' 2>/dev/null | sed 's|http://||')
KOURIER_IP=$(kubectl -n kourier-system get svc kourier -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "")

if [ -z "$HOST" ] || [ -z "$KOURIER_IP" ]; then
  echo "Could not resolve the Knative Service host or Kourier's ClusterIP."
  exit 1
fi

RESPONSE=$(kubectl run curler-verify --image=busybox:1.36 --restart=Never --rm -i --command -- \
  wget -qO- --header "Host: $HOST" "http://$KOURIER_IP" 2>/dev/null || echo "FAILED")

if [[ "$RESPONSE" != *"Hello World: KCNA!"* ]]; then
  echo "Expected 'Hello World: KCNA!' from the Knative Service, got: '$RESPONSE'."
  exit 1
fi

echo "Knative Service 'hello' reachable through Kourier and returning the expected response."
exit 0
