FROM ubuntu:19.04

ARG BUILD_TIME="<unspecified build time>"
ARG GIT_REV="<unspecified Git revision>"

LABEL \
    description="Build environment for C++ projects" \
    maintainer="Stig Sandnes <stig_sandnes@hotmail.com>" \
    build.date="${BUILD_TIME}" \
    vcs.ref="${GIT_REV}"
