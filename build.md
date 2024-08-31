## 基础镜像

带有 Python 和 node 环境的 Ubuntu 镜像

#### 本地安装包

##### x86

```shell
docker build -f Dockerfile.base -t basenv --build-arg local=1 --build-arg node_package=./node-v20.14.0-linux-x64.tar.gz --build-arg conda_package=./Miniconda3-latest-Linux-x86_64.sh .
```

##### arm

```shell
docker build -f Dockerfile.base -t basenv --build-arg local=1 --build-arg node_package=./node-v20.14.0-linux-arm64.tar.gz --build-arg conda_package=./Miniconda3-latest-Linux-aarch64.sh .
```

#### 远程安装包

```shell
docker build -f Dockerfile.base -t basenv .
```
