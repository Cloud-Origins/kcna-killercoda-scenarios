#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

touch /tmp/kcna-background-done
