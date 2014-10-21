#!/bin/bash

inst=${1:-1}
baseimg=${2:-bryantsai/db2-expc}
port=50000

docker run -i --hostname=db2_inst_$inst --name=db2_data_$inst -v /home busybox true \
 && docker run -i --volumes-from=db2_data_$inst --hostname=db2_inst_$inst --name=db2_inst_$inst $baseimg /bin/bash <<EOF
userdel dasusr1;userdel db2fenc1;userdel db2inst1;groupdel dasadm1;groupdel db2fgrp1;groupdel db2grp1
groupadd db2grp1;groupadd db2fgrp1;groupadd dasadm1;useradd -g db2grp1 -m -d /home/db2inst1 db2inst1 -p db2inst1;useradd -g db2fgrp1 -m -d /home/db2fenc1 db2fenc1 -p db2fenc1;useradd -g dasadm1 -m -d /home/dasusr1 dasusr1 -p dasusr1
/opt/ibm/db2/V10.5/instance/db2icrt -p $port -u db2fenc1 db2inst1
exit
EOF
ID=$(docker ps -l|grep $baseimg|awk '{print $1}')
docker commit --author="$maintainer" $ID $baseimg:db2_inst_$inst
docker rm $ID
