#!/bin/bash
set -xeu

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"

export PGUSER=${PGUSER:-postgres}
export PGDATA=${PGDATA:-/pg_data}

MEMCACHE_URI=${MEMCACHE_URI:=-""}
MAS_DB_POOL_SIZE=${MAS_DB_POOL_SIZE:-2}

WEBHOOK_SECRET=${WEBHOOK_SECRET:-""}
WEBHOOK_ENABLED=${WEBHOOK_ENABLED:-false}

masapi_port=8888

rm -rf /var/run/postgresql
mkdir -p /var/run/postgresql

su -p -c "pg_ctl -w start" -l "$PGUSER"

# masapi requires postgresql unix domain socket under /var/run
ln -s /tmp/.s.PGSQL.5432 /var/run/postgresql/.s.PGSQL.5432

bash /ingest.sh

./gsky/bin/masapi -port $masapi_port -pool $MAS_DB_POOL_SIZE -memcache $MEMCACHE_URI > masapi_output.log 2>&1 &

set +x
echo
echo
echo '=========================================================='
echo "GSKY MAS API listening on port: $masapi_port "
echo
echo "MAS API end point:       http://127.0.0.1:$masapi_port"
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