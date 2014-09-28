#!/bin/bash
docker build -t bryantsai/db2-expc .
./create-inst.sh "$@"
