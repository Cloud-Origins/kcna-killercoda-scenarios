echo "Provisioning scenario environment -- this happens automatically, sit tight."
while [ ! -f /tmp/kcna-background-done ]; do sleep 1; done
echo "Environment ready."
