#!/bin/bash
set -xeu

# MSG SEVIRI DATA
/ingest.sh -n natural_color_with_night_ir_hires -p /gskydata/sdi/natural_color_with_night_ir_hires -t tif -x "-conf /rulesets/namespace_layer_yyy-mm-ddTHM.tif.json"