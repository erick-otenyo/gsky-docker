#!/bin/bash
set -xeu

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"

WEBHOOK_SECRET=${WEBHOOK_SECRET:-""}
WEBHOOK_ENABLED=${WEBHOOK_ENABLED:-false}

GSKY_WMS_GEOMS_FILE=${GSKY_WMS_GEOMS_FILE:-""}

ows_port=8080

./gsky/bin/gsky-ows -p $ows_port -geom_file $GSKY_WMS_GEOMS_FILE -v  &
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

if [ "$WEBHOOK_ENABLED" = true ] && [ -n "$WEBHOOK_SECRET" ]
then
  # Replace secret key for webhooks from env
  sed -i 's/\[WEBHOOK_SECRET\]/'${WEBHOOK_SECRET}'/' /hooks.conf
  ./webhook -hooks /hooks.conf -verbose

  echo '=========================================================='
  echo "Webhooks end point:       http://127.0.0.1:9000"
  echo '=========================================================='

else
  echo "Webhooks not enabled"
fi

wait