#!/bin/bash
set -xeu

# GFS Precipitation 1 Hour
/ingest.sh -n gfs_precipitation_1_hr -p /gskydata/gfs/gfs-precipitation-1-hr -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Temperature
/ingest.sh -n gfs_temperature_2_m -p /gskydata/gfs/gfs-temperature-2-m -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n gfs_temperature_200_mb -p /gskydata/gfs/gfs-temperature-200-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n gfs_temperature_500_mb -p /gskydata/gfs/gfs-temperature-500-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Wind
/ingest.sh -n gfs_wind_10_m -p /gskydata/gfs/gfs-wind-10-m -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n gfs_wind_200_mb -p /gskydata/gfs/gfs-wind-200-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n gfs_wind_500_mb -p /gskydata/gfs/gfs-wind-500-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Wind Speed
# /ingest.sh -n gfs_wind_speed_10_m -p /gskydata/gfs/gfs-wind-speed-10-m -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
# /ingest.sh -n gfs_wind_speed_200_mb -p /gskydata/gfs/gfs-wind-speed-200-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
# /ingest.sh -n gfs_wind_speed_500_mb -p /gskydata/gfs/gfs-wind-speed-500-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Relative Humidity
/ingest.sh -n gfs_relative_humidity_2_m -p /gskydata/gfs/gfs-relative-humidity-2-m -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n gfs_relative_humidity_200_mb -p /gskydata/gfs/gfs-relative-humidity-200-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"
/ingest.sh -n gfs_relative_humidity_500_mb -p /gskydata/gfs/gfs-relative-humidity-500-mb -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Mean Sea Level Pressure
/ingest.sh -n gfs_mean_sea_level_pressure -p /gskydata/gfs/gfs-mean-sea-level-pressure -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Precipitable Water Total
/ingest.sh -n gfs_precipitable_water_total -p /gskydata/gfs/gfs-precipitable-water-total -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Cloud Water Total
/ingest.sh -n gfs_cloud_water_total -p /gskydata/gfs/gfs-cloud-water-total -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"

# GFS Sunshine
/ingest.sh -n gfs_sunshine_1_hr -p /gskydata/gfs/gfs-sunshine-1-hr -t tif -x "-conf /rulesets/namespace_yyy-mm-ddTH.tif.json"