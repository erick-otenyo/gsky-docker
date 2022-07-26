#!/bin/bash
set -eu

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"

export PGUSER=${PGUSER:-postgres}
export PGDATA=${PGDATA:-/pg_data}

MEMCACHE_URI=${MEMCACHE_URI:=-""}
MAS_DB_POOL_SIZE=${MAS_DB_POOL_SIZE:-2}

WEBHOOK_SECRET=${WEBHOOK_SECRET:-""}
WEBHOOK_ENABLED=${WEBHOOK_ENABLED:-false}

# Check if the public.shards table already exists. If not, we need to initialize the schemas and functions for mas
# This is to avoid recreating the MAS tables each time we restart, especially when using a volume to store database data
if [ "$(psql -d ${PGDB} -XtAc "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'shards')")" = 't' ]
then
    echo "MAS database already initialized. Skipping..."
else
    echo "Initializing MAS database"
    ls /gsky/share/mas
    (cd /gsky/share/mas && PGPASSWORD=${PGPASSWORD} psql -h ${PGHOST} -p 5432  -U ${PGUSER} -d ${PGDB} -f schema.sql)
    (cd /gsky/share/mas && PGPASSWORD=${PGPASSWORD} psql -h ${PGHOST} -p 5432  -U ${PGUSER} -d ${PGDB} -f mas.sql)
fi

masapi_port=8888

# Start MAS API server
./gsky/bin/masapi -port $masapi_port -pool $MAS_DB_POOL_SIZE -memcache $MEMCACHE_URI -dbhost ${PGHOST} -database ${PGDB} -user ${PGUSER} -password ${PGPASSWORD} > masapi_output.log 2>&1 &


set +
echo
echo
echo '=========================================================='
echo "GSKY MAS API listening on port: $masapi_port "
echo
echo "MAS API end point:       http://127.0.0.1:$masapi_port"
echo
echo '=========================================================='


# Webhooks to reload data
if [ "$WEBHOOK_ENABLED" = true ] && [ -n "$WEBHOOK_SECRET" ]; then
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