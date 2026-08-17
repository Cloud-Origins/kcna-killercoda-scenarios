#!/bin/bash
set -e

RESULT_FILE="/root/kcna-scratch/dashboard-result.json"
if [ ! -f "$RESULT_FILE" ]; then
  echo "No saved dashboard creation result at $RESULT_FILE."
  exit 1
fi

if ! grep -q '"status":"success"' "$RESULT_FILE"; then
  echo "Dashboard creation did not report success."
  exit 1
fi

PANEL_FILE="/root/kcna-scratch/panel-data.json"
if [ ! -f "$PANEL_FILE" ]; then
  echo "No saved panel data at $PANEL_FILE."
  exit 1
fi

if ! grep -q '"status":"success"' "$PANEL_FILE"; then
  echo "Panel data query through the Grafana proxy did not succeed."
  exit 1
fi

if ! grep -q '"1"' "$PANEL_FILE"; then
  echo "Panel data shows no target with value '1' -- the dashboard's data isn't actually live."
  exit 1
fi

echo "Dashboard created and its panel query confirmed to carry real, live metric data."
exit 0
