FROM ubuntu:latest

USER  root

ARG local
# x86
# ARG node_package=https://nodejs.org/dist/v20.10.0/node-v20.14.0-linux-x64.tar.gz
# ARG conda_package=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# arm64
ARG node_package=https://nodejs.org/dist/v20.14.0/node-v20.14.0-linux-arm64.tar.gz
ARG conda_package=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh

# ubuntu
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt update && apt install -y wget curl openssh-server vim git xz-utils build-essential && mkdir ~/.pip && cd ~/.pip && echo [global] >> pip.conf && echo "index-url = http://mirrors.aliyun.com/pypi/simple/">>pip.conf && echo [install]>>pip.conf && echo "trusted-host=mirrors.aliyun.com">>pip.conf


# node
ENV NODE_PATH=/root/node/bin
ENV PATH=$PATH:$NODE_PATH

WORKDIR /root/node/
# 如果从远程添加不会自动解压缩
ADD ${node_package} ./
RUN [ -n "$local" ] || (tar -xvf node-* && rm -rf *.tar.gz)
RUN cd /root/node && mv node-*/* . && rm -rf node-* && npm config set registry https://registry.npmmirror.com && npm i -g pnpm pm2

# miniconda
WORKDIR /root/miniconda3
ADD ${conda_package} ./miniconda.sh
RUN bash ./miniconda.sh -b -u -p ./ && rm -rf .miniconda.sh && ./bin/conda init bash


WORKDIR /workspace

# 暴漏常用端口
EXPOSE 3000 22 27017 6379 3306 8000 8080 3003 3001 3002
# 使容器保持启动状态
CMD ["tail", "-f", "/dev/null"]