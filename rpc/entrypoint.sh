#!/bin/bash
set -eu

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"

rpc_port=6000

n_cores=$(grep -c 'cpu[0-9]' /proc/stat)
if [[ ! "$n_cores" =~ ^[0-9]+$ ]]
then
  echo 'cannot determine number of cpu cores, using default value 1'
  n_cores=1
elif [ $n_cores -lt 2 ]
then
  n_cores=1
fi

./gsky/bin/gsky-rpc -p $rpc_port -n $n_cores > rpc_output.log 2>&1 &
sleep 1

set +x
echo
echo
echo '========================================================'
echo "GSKY RPC Listening on port: $rpc_port"
echo
echo '========================================================'

wait