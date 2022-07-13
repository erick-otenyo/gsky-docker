#!/bin/bash
set -xeu

v=1.16.3
wget -q https://dl.google.com/go/go${v}.linux-amd64.tar.gz -O go.tar.gz
tar -xzf go.tar.gz -C /usr/local/ 
rm -f go.tar.gz