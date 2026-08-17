#!/bin/bash
set -e

FILE="/root/kcna-scratch/datasources.json"
if [ ! -f "$FILE" ]; then
  echo "No saved datasources response at $FILE."
  exit 1
fi

if ! grep -q '"type":"prometheus"' "$FILE"; then
  echo "Saved datasources response does not show a datasource of type 'prometheus'."
  exit 1
fi

if ! grep -q 'prometheus-server.monitoring' "$FILE"; then
  echo "Saved datasources response does not point at prometheus-server.monitoring."
  exit 1
fi

echo "Grafana is up with a correctly provisioned Prometheus datasource."
exit 0
