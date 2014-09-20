#!/bin/bash
docker build -t db2:expc .
./create-inst.sh "$@"
