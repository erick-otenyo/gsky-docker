#!/bin/bash
set -eu

ls /gsky/share/mas
(cd /gsky/share/mas && psql -h ${PGHOST} -p 5432  -U ${PGUSER} -d ${PGDB} -f schema.sql)
(cd /gsky/share/mas && psql -h ${PGHOST} -p 5432  -U ${PGUSER} -d ${PGDB} -f mas.sql)

echo "MAS database tables have been recreated. All existing data has been deleted"