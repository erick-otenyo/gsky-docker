#!/bin/bash
set -eu

# ingest NetCDF
/ingest.sh -n dataset_namespace -p /gskydata/path/to/your/data -t nc

# ingest Geotiff Data
/ingest.sh -n dataset_namespace -p /gskydata/path/to/your/data -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"