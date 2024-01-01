FROM ubuntu
RUN apt update && apt install -y wget curl openssh-server vim git xz-utils && bash -c "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config" && bash -c "echo 'root:123' | chpasswd"

# miniconda
RUN mkdir -p ~/miniconda3 && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh && bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && rm -rf ~/miniconda3/miniconda.sh && ~/miniconda3/bin/conda init bash && bash -c "source ~/.bashrc" 

# node
RUN mkdir -p ~/node && cd ~/node && wget https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-arm64.tar.xz && tar -xvf node-* && mv node-*/* . && rm -rf node-* && echo NODE_PATH=/root/node/bin >> ~/.bashrc && echo 'PATH=$PATH:$NODE_PATH' >> ~/.bashrc && bash -c "source ~/.bashrc" 
EXPOSE 22
CMD ["service","ssh","start"]
