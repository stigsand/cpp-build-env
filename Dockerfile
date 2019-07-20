FROM ubuntu:19.04

ARG BUILD_TIME="<unspecified build time>"
ARG GIT_REV="<unspecified Git revision>"

LABEL \
    description="Build environment for C++ projects" \
    maintainer="Stig Sandnes <stig_sandnes@hotmail.com>" \
    build.date="${BUILD_TIME}" \
    vcs.ref="${GIT_REV}"

RUN apt-get update
# ToDo: Squash layers
RUN apt-get install --yes --no-install-recommends \
    python3 \
    python3-pip \
    python3-setuptools \
    && pip3 install wheel==0.33.4 \
    && pip3 install conan==1.17.0
