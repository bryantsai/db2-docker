#!/bin/bash
inst=${1:-1}
docker run --privileged=true --rm=true -i -t -P --volumes-from=db2_data_$inst --name=db2_inst_$inst bryantsai/db2-expc /bin/su -c '/home/db2inst1/sqllib/adm/db2start;/bin/bash' - db2inst1
