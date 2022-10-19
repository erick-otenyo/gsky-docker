#!/bin/bash
set -xeu

C_INCLUDE_PATH=$(nc-config --includedir)
export C_INCLUDE_PATH

DEFAULT_GSKY_REPO='https://github.com/icpac-igad/gsky.git'
gsky_repo="${gsky_repo:-$DEFAULT_GSKY_REPO}"
gsky_branch=${gsky_branch:-dev}

echo "Building GSKY from $gsky_repo with branch $gsky_branch"

gsky_src_root=/gsky/gsky_src
mkdir -p $gsky_src_root

git clone "$gsky_repo" $gsky_src_root/gsky

(
    set -xeu
    cd $gsky_src_root/gsky

    if [ ! -z "$gsky_branch" ]; then
        git checkout "$gsky_branch"
    fi

    ./configure --prefix=/gsky --bindir=/gsky/bin --sbindir=/gsky/bin --libexecdir=/gsky/bin
    make all
    make install
)
