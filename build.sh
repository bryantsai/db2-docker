#!/bin/bash

shopt -s nocasematch

cmdline='build.sh <db2 install package> [license files...]'
srcimg=$1
if [[ -z "$srcimg" ]]; then
  echo missing absolute path to DB2 install package as the first argument
  echo $cmdline
  exit
elif ! [[ $srcimg =~ \.tar\.gz$ ]] && ! [[ $srcimg =~ \.tgz$ ]] ; then
  echo DB2 install package must be gzipped tar ball \(*.tgz or *.tar.gz\)
  echo $cmdline
  exit
elif ! [ "${srcimg:0:1}" = "/" ]; then
  srcimg=`pwd`/$srcimg
fi
if ! [ -e "$srcimg" ]; then
  echo file not found: $srcimg
  echo $cmdline
  exit
fi

inst=1
port=50000

baseimg=ubuntu:14.10
maintainer=bryantsai

prod=expc
if [[ $srcimg =~ DB2_Svr ]]; then
  prod=server
fi
tag=$maintainer/db2-$prod

for arg in "$@"
do
  if ! [ "${arg:0:1}" = "/" ]; then
    arg=`pwd`/$arg
  fi
  if [ -e "$srcimg" ] && [[ $arg =~ \.lic$ ]]; then
    LIC=$LIC' -v '$arg:/tmp/${arg##*/}
  fi
done

docker run -i -v $srcimg:/tmp/db2.tar.gz -v `pwd`/db2$prod.rsp:/tmp/db2.rsp $LIC -p $port $baseimg /bin/bash <<EOF
dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get -y install libpam0g:i386 libaio1 libstdc++6 lib32stdc++6 binutils \
 && ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0
rm -rf /var/lib/apt/lists/*
groupadd db2grp1;groupadd db2fgrp1;groupadd dasadm1 \
 && useradd -g db2grp1 -m -d /home/db2inst1 db2inst1 -p db2inst1 \
 && useradd -g db2fgrp1 -m -d /home/db2fenc1 db2fenc1 -p db2fenc1 \
 && useradd -g dasadm1 -m -d /home/dasusr1 dasusr1 -p dasusr1
cd /tmp; tar xvzf db2.tar.gz \
 && /tmp/$prod/db2setup -r /tmp/db2.rsp \
 && rm -fr /tmp/$prod
ls /tmp/*.lic &> /dev/null && /opt/ibm/db2/V10.5/adm/db2licm -a /tmp/*.lic
exit
EOF
ID=$(docker ps -l|grep $baseimg|awk '{print $1}')
docker commit --author="$maintainer" $ID $tag
docker rm $ID

./create-inst.sh $inst $tag
