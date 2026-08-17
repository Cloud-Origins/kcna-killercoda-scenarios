#!/bin/bash
set -e

CM_VALUE=$(kubectl get configmap app-config -o jsonpath='{.data.APP_MODE}' 2>/dev/null || echo "")
if [ "$CM_VALUE" != "production" ]; then
  echo "ConfigMap 'app-config' key APP_MODE is '$CM_VALUE', expected 'production'."
  exit 1
fi

SECRET_TYPE=$(kubectl get secret app-secret -o jsonpath='{.type}' 2>/dev/null || echo "")
if [ "$SECRET_TYPE" != "Opaque" ]; then
  echo "Secret 'app-secret' type is '$SECRET_TYPE', expected 'Opaque'."
  exit 1
fi

SECRET_VALUE=$(kubectl get secret app-secret -o jsonpath='{.data.API_KEY}' 2>/dev/null | base64 -d 2>/dev/null || echo "")
if [ "$SECRET_VALUE" != "s3cr3t" ]; then
  echo "Secret 'app-secret' key API_KEY decodes to '$SECRET_VALUE', expected 's3cr3t'."
  exit 1
fi

echo "ConfigMap and Secret correctly created."
exit 0
