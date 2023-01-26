#!/bin/bash
set -xeu

/ingest.sh -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTHM.tif.json" "$@"