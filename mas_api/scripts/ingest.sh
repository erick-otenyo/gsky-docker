#!/bin/bash
set -xeu

/ingest_data.sh daily_total_rainfall /gskydata/RAINFALL/DAILY "*.nc"

/ingest_data.sh chirps_daily /gskydata/CHIRPS/DAILY "*.tif"  "-conf /rulesets/chirps_daily.json"