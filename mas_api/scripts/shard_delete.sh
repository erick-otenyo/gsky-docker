#!/bin/bash

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
shard=$1

if [ $shard == "public" ]; then
    echo "Can not delete public" >&2 && exit 1
fi

ret=$(cd "$here" && psql -v ON_ERROR_STOP=1 -A -t -q -d mas <<EOD
select 1 from public.shards where sh_code = '${shard}' limit 1;
EOD
) && [ -z "$ret" ] && echo "Shard '${shard}' does not exist" >&2 && exit 1

(cd "$here" && psql -v ON_ERROR_STOP=1 -A -t -q -d mas <<EOD
set role mas;
drop schema if exists ${shard} cascade;
delete from public.shards where sh_code = '${shard}';
select public.mas_refresh_caches();
EOD
)