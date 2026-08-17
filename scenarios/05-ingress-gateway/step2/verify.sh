#!/bin/bash
set -e

BACKEND1=$(kubectl get ingress apps-ingress -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/app1")].backend.service.name}')
BACKEND2=$(kubectl get ingress apps-ingress -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/app2")].backend.service.name}')

if [ "$BACKEND1" != "app1-svc" ] || [ "$BACKEND2" != "app2-svc" ]; then
  echo "Expected /app1 -> app1-svc and /app2 -> app2-svc, found '$BACKEND1' and '$BACKEND2'."
  exit 1
fi

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

if ! curl -s "http://$NODE_IP:$NODE_PORT/app2" | grep -qi "server address"; then
  echo "Could not reach app2 via the ingress at $NODE_IP:$NODE_PORT/app2."
  exit 1
fi

echo "apps-ingress correctly routes both /app1 and /app2 on one Ingress object."
exit 0
