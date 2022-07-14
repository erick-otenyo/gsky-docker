#!/bin/bash
set -xeu

export GO111MODULE=auto

go get github.com/adnanh/webhook

go build github.com/adnanh/webhook