#!/bin/bash
inst=${1:-1}
baseimg=${2:-bryantsai/db2-expc}
docker kill db2_inst_$inst
docker rm -v db2_inst_$inst
docker rm -v db2_data_$inst
docker rmi $baseimg:db2_inst_$inst
