FROM ubuntu:19.04

ARG GIT_REV="<unspecified Git revision>"

LABEL \
    description="Build environment for C++ projects" \
    maintainer="Stig Sandnes <stig_sandnes@hotmail.com>" \
    vcs.ref="${GIT_REV}"
