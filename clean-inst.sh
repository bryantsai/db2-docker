#!/bin/bash
inst=${1:-1}
docker kill db2_inst_$inst
docker rm -v db2_inst_$inst
docker rm -v db2_data_$inst
