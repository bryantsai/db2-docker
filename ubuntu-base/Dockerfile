FROM ubuntu:14.10
MAINTAINER bryantsai

RUN dpkg --add-architecture i386;apt-get update;apt-get -y install libpam0g:i386 libaio1 libstdc++6 lib32stdc++6 binutils

CMD ["/bin/bash"]
