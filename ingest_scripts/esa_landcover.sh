#!/bin/bash
set -xeu

/ingest.sh -n esa_worldcover -p /gskydata/landcover -t tif -x "-conf /rulesets/namespace.extra.yyy-mm-ddTH.tif.json"
