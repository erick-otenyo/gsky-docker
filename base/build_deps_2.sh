#!/bin/bash
set -xeu

prefix=${PREFIX:-/usr}

v=4.2.15
(
    set -xeu
    wget -q https://support.hdfgroup.org/ftp/HDF/releases/HDF${v}/src/hdf-${v}.tar.gz
    tar -xf hdf-${v}.tar.gz
    cd hdf-${v}
    ./configure --enable-shared --disable-fortran --prefix="$prefix" --enable-hdf4-xdr
    make -j4
    make install
)
rm -rf hdf-${v}
rm -f hdf-${v}.tar.gz

v=1.8.13
(
    set -xeu
    wget -q ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/hdf5-${v}.tar.gz
    tar -xf hdf5-${v}.tar.gz && cd hdf5-${v}
    ./configure --enable-shared --enable-hl --prefix="$prefix"
    make -j4
    make install
)
rm -rf hdf5-${v}
rm -f hdf5-${v}.tar.gz

v=4.7.0
(
    set -xeu
    wget -q https://github.com/Unidata/netcdf-c/archive/v${v}.tar.gz -O netcdf-c-${v}.tar.gz
    tar -xf netcdf-c-${v}.tar.gz && cd netcdf-c-${v}
    export CFLAGS="-O2 -DHAVE_STRDUP"
    autoreconf
    ./configure --with-max-default-cache-size=67108864 --with-chunk-cache-size=67108864 --enable-netcdf-4 --enable-shared --enable-dap --prefix="$prefix"
    make -j4
    make install
)
rm -rf netcdf-c-${v}
rm -f netcdf-c-${v}.tar.gz