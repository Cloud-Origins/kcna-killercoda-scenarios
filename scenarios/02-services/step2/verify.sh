#!/bin/bash
set -e

if ! kubectl get svc backend-nodeport &>/dev/null; then
  echo "Service 'backend-nodeport' not found."
  exit 1
fi

TYPE=$(kubectl get svc backend-nodeport -o jsonpath='{.spec.type}')
NODEPORT=$(kubectl get svc backend-nodeport -o jsonpath='{.spec.ports[0].nodePort}')

if [ "$TYPE" != "NodePort" ]; then
  echo "backend-nodeport is type '$TYPE', expected NodePort."
  exit 1
fi

if [ "$NODEPORT" != "30080" ]; then
  echo "NodePort is $NODEPORT, expected 30080."
  exit 1
fi

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
if ! curl -s -o /dev/null -w "%{http_code}" "http://$NODE_IP:30080" | grep -q "200"; then
  echo "Could not reach backend via $NODE_IP:30080."
  exit 1
fi

echo "backend-nodeport reachable on $NODE_IP:30080."
exit 0
