#!/bin/bash
docker build -t db2:ubuntu-base ubuntu-base
docker build -t db2:expc expc

./create-inst.sh "$@"
