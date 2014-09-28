#!/bin/bash
inst=${1:-1}
docker run --privileged=true -d -P --volumes-from=db2_data_$inst --name=db2_inst_$inst bryantsai/db2-expc /bin/su -c '/home/db2inst1/sqllib/adm/db2start && tail -f /dev/null' - db2inst1
