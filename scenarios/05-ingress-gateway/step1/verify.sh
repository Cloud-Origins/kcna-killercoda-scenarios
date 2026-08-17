#!/bin/bash
set -e

if ! kubectl get ingress apps-ingress &>/dev/null; then
  echo "Ingress 'apps-ingress' not found."
  exit 1
fi

BACKEND=$(kubectl get ingress apps-ingress -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/app1")].backend.service.name}')
if [ "$BACKEND" != "app1-svc" ]; then
  echo "/app1 does not route to app1-svc (found: '$BACKEND')."
  exit 1
fi

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

if ! curl -s "http://$NODE_IP:$NODE_PORT/app1" | grep -qi "server address"; then
  echo "Could not reach app1 via the ingress at $NODE_IP:$NODE_PORT/app1."
  exit 1
fi

echo "apps-ingress correctly routes /app1 to app1-svc."
exit 0
