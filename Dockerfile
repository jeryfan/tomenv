
FROM ubuntu:24.04 AS base
USER root

ARG ARCH=arm64
ENV LIGHTEN=0

WORKDIR /workspace


RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,id=base_apt,target=/var/cache/apt,sharing=locked \
    apt update && apt-get --no-install-recommends install -y ca-certificates

RUN sed -i 's|http://archive.ubuntu.com|https://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list.d/ubuntu.sources

RUN --mount=type=cache,id=base_apt,target=/var/cache/apt,sharing=locked \
    apt update && apt install -y curl libpython3-dev nginx libglib2.0-0 libglx-mesa0 pkg-config libicu-dev libgdiplus default-jdk python3-pip pipx \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,id=base_apt,target=/var/cache/apt,sharing=locked \
    apt update && apt install -y nodejs npm cargo && \
    rm -rf /var/lib/apt/lists/*


RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && pip3 config set global.trusted-host "pypi.tuna.tsinghua.edu.cn mirrors.pku.edu.cn" && pip3 config set global.extra-index-url "https://mirrors.pku.edu.cn/pypi/web/simple" \
    && pipx install poetry \
    && /root/.local/bin/poetry self add poetry-plugin-pypi-mirror

RUN --mount=type=bind,source=libssl1.1_1.1.1f-1ubuntu2.23_${ARCH}.deb,target=/root/libssl1.1_1.1.1f-1ubuntu2_${ARCH}.deb

ENV PYTHONDONTWRITEBYTECODE=1 DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
ENV PATH=/root/.local/bin:$PATH
# Configure Poetry
ENV POETRY_NO_INTERACTION=1
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_VIRTUALENVS_CREATE=true
ENV POETRY_REQUESTS_TIMEOUT=15
ENV POETRY_PYPI_MIRROR_URL=https://pypi.tuna.tsinghua.edu.cn/simple/


# COPY entrypoint.sh ./entrypoint.sh
# RUN chmod +x ./entrypoint.sh
# ENTRYPOINT ["./entrypoint.sh"]