FROM ubuntu:latest

USER  root


# ubuntu
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt update && apt install -y wget curl openssh-server vim git xz-utils && mkdir ~/.pip && cd ~/.pip && echo [global] >> pip.conf && echo "index-url = http://mirrors.aliyun.com/pypi/simple/">>pip.conf && echo [install]>>pip.conf && echo "trusted-host=mirrors.aliyun.com">>pip.conf

ARG local
# arm64
ARG node_package=https://nodejs.org/dist/v20.14.0/node-v20.14.0-linux-arm64.tar.gz

# node
ENV NODE_PATH=/root/node/bin
ENV PATH=$PATH:$NODE_PATH

WORKDIR /root/node/
ADD ${node_package} ./

