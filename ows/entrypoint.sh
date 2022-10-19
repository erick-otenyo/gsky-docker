#!/bin/bash
set -eu

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"

WEBHOOK_SECRET=${WEBHOOK_SECRET:-""}
WEBHOOK_ENABLED=${WEBHOOK_ENABLED:-false}

OWS_HOSTNAME=${OWS_HOSTNAME:-'127.0.0.1:8080'}
OWS_PROTOCOL=${OWS_PROTOCOL:-'http'}
MAS_ADDRESS=${MAS_ADDRESS:-'127.0.0.1:8888'}
WORKER_NODES=${WORKER_NODES:-'127.0.0.1:6000'}

WORKER_NODES=', ' read -r -a array <<<$WORKER_NODES

MEMCACHE_URI=${MEMCACHE_URI:=-""}

# update config.json files
config_dir="/gsky/etc"
config_files=$(find $config_dir -type f -name '*.json')

for file in $config_files
do
  tmp=$(mktemp)
  jq '.service_config |= . + {"ows_hostname":"'${OWS_HOSTNAME}'","ows_protocol":"'${OWS_PROTOCOL}'","mas_address":"'${MAS_ADDRESS}'", "worker_nodes":['${WORKER_NODES}']}' \
  $file >"$tmp" && mv "$tmp" $file
done;

ows_port=8080

./gsky/bin/gsky-ows -p $ows_port -memcache $MEMCACHE_URI -v &

sleep 0.5

set +x
echo
echo
echo '=========================================================='
echo 'Welcome to GSKY OWS'
echo
echo "GSKY WMS/WCS end point:  http://127.0.0.1:$ows_port/ows"
echo
echo '=========================================================='

if [ "$WEBHOOK_ENABLED" = true ] && [ -n "$WEBHOOK_SECRET" ]; then
  # Replace secret key for webhooks from env
  sed -i 's/\[WEBHOOK_SECRET\]/'${WEBHOOK_SECRET}'/' /hooks.yaml
  ./webhook -hooks /hooks.yaml -verbose
else
  echo "Webhooks not enabled"
fi

wait
