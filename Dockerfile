FROM ubuntu:14.10
MAINTAINER bryantsai

ADD v10.5_linuxx64_expc.tar.gz /tmp/v10.5_linuxx64_expc.tar.gz
ADD db2expc.rsp /tmp/db2expc.rsp

RUN dpkg --add-architecture i386;apt-get update;apt-get -y install libpam0g:i386 libaio1 libstdc++6 lib32stdc++6 binutils
RUN groupadd db2grp1;groupadd db2fgrp1;groupadd dasadm1;useradd -g db2grp1 -m -d /home/db2inst1 db2inst1 -p db2inst1;useradd -g db2fgrp1 -m -d /home/db2fenc1 db2fenc1 -p db2fenc1;useradd -g dasadm1 -m -d /home/dasusr1 dasusr1 -p dasusr1;/tmp/v10.5_linuxx64_expc.tar.gz/expc/db2setup -r /tmp/db2expc.rsp

EXPOSE 50000

CMD ["/bin/bash"]
