#!/bin/bash
set -xeu

# ERA5
/ingest.sh -n era5monthly_temperature_2_m -p /gskydata/era5/era5monthly-temperature-2-m -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n era5monthly_temperature_2_m_anomaly -p /gskydata/era5/era5monthly-temperature-2-m-anomaly -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

/ingest.sh -n era5monthly_precipitation_1_day -p /gskydata/era5/era5monthly-precipitation-1-day -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n era5monthly_precipitation_1_day_anomaly -p /gskydata/era5/era5monthly-precipitation-1-day-anomaly -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
