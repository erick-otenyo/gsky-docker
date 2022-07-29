#!/bin/bash

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
else
    echo "Unknown data type '${datatype}'. Must be 'nc' or 'tif' " >&2
    exit 1
fi

# run crawl command
/ingest_data.sh ${namespace} ${path} ${datatype} "${extra}"