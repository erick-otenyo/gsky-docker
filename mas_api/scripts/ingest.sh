#!/bin/bash

# Script to help in crawling directories
# This script ensures you only crawl the namespace and directories you want, and not everything.

# Example usage
#/ingest.sh -n daily_total_rainfall -p /gskydata/RAINFALL/DAILY -t nc 

# -n = dataset namespace
# -p = path to the directory where the files to be crawled are stored
# -t = the data type extensions to crawls. Must be either nc for NetCDFs or tif for Geotiffs, without the dot "."
# -x = optional args to pass to the crawler. Please consult the crawl code for available options

# With extra args:
# /ingest.sh -n chirps_daily -p /gskydata/CHIRPS/DAILY -t tif -x "-conf /rulesets/chirps_daily.json"

set -xeu

namespace=""
path=""
datatype=""
extra=""

while getopts n:p:t:x: opt; do
    case $opt in
    n) namespace=$OPTARG ;;
    p) path=$OPTARG ;;
    t) datatype=$OPTARG ;;
    x) extra="$OPTARG" ;;
    *)
        echo 'Error in command line parsing' >&2
        exit 1
        ;;
    esac
done

shift "$((OPTIND - 1))"

if [ -z "$namespace" ]; then
    echo 'Missing -n (data namespace)' >&2
    exit 1
fi

if [ -z "$path" ]; then
    echo 'Missing -p (path to data directory)' >&2
    exit 1
fi

if [ -z "$datatype" ]; then
    echo "Missing -t (datatype). Must be 'nc' or 'tif' " >&2
    exit 1
else
    # remove all whitespaces
    datatype="$(echo -e "${datatype}" | tr -d '[:space:]')"
fi

if [ "$datatype" = "nc" ]; then
    datatype="*.nc";
elif [ "$datatype" = "tif" ]; then
    datatype="*.tif";
elif [ "$datatype" = "grib" ]; then
    datatype="*.grib";
elif [ "$datatype" = "vrt" ]; then
    datatype="*.vrt";
else
    echo "Unknown data type '${datatype}'. Must be 'nc' or 'tif' " >&2
    exit 1
fi

# run crawl command
/ingest_data.sh ${namespace} ${path} ${datatype} "${extra}"





