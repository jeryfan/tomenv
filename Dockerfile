FROM ubuntu

RUN apt update && apt install -y wget curl openssh-server vim git xz-utils && mkdir /var/run/sshd && echo 'root:123' | chpasswd && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && mkdir /data && mkdir ~/.pip && cd ~/.pip && echo [global] >> pip.conf && echo "index-url = http://mirrors.aliyun.com/pypi/simple/">>pip.conf && echo [install]>>pip.conf && echo "trusted-host=mirrors.aliyun.com">>pip.conf

# miniconda
RUN mkdir -p ~/miniconda3 && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh && bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && rm -rf ~/miniconda3/miniconda.sh && ~/miniconda3/bin/conda init bash

# node
RUN mkdir -p ~/node && cd ~/node && wget https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-arm64.tar.xz && tar -xvf node-* && mv node-*/* . && rm -rf node-* && echo NODE_PATH=/root/node/bin >> ~/.bashrc && echo 'PATH=$PATH:$NODE_PATH' >> ~/.bashrc

WORKDIR /data

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
