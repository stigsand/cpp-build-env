FROM ubuntu:19.04

ARG BUILD_TIME="<unspecified build time>"
ARG GIT_REV="<unspecified Git revision>"

LABEL \
    description="Build environment for C++ projects" \
    maintainer="Stig Sandnes <stig_sandnes@hotmail.com>" \
    build.date="${BUILD_TIME}" \
    vcs.ref="${GIT_REV}"

RUN apt-get update && apt-get install --yes --no-install-recommends software-properties-common

RUN add-apt-repository --update --yes ppa:ubuntu-toolchain-r/ppa \
    && apt-get install --yes --no-install-recommends \
    gcc-9=9.1.0-2ubuntu2~19.04 \
    g++-9=9.1.0-2ubuntu2~19.04

RUN update-alternatives \
        --install /usr/bin/gcc gcc /usr/bin/gcc-9 100 \
        --slave /usr/bin/g++ g++ /usr/bin/g++-9

RUN apt-get update && apt-get install --yes --no-install-recommends \
    python3=3.7.3-1 \
    python3-pip=18.1-5 \
    python3-setuptools=40.8.0-1 \
    && pip3 install wheel==0.33.6 \
    && pip3 install conan==1.18.1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
