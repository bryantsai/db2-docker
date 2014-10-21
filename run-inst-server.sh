#!/bin/bash
inst=${1:-1}
baseimg=${2:-bryantsai/db2-expc}
docker run --privileged=true -d -P --volumes-from=db2_data_$inst --hostname=db2_inst_$inst --name=db2_inst_$inst $baseimg:db2_inst_$inst /bin/su -c '/home/db2inst1/sqllib/adm/db2start && tail -f /dev/null' - db2inst1
