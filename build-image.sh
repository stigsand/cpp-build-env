#!/usr/bin/env bash

set -e

docker image build \
    --file Dockerfile \
    --build-arg GIT_REV="$(git rev-parse --short=8 HEAD)" \
    --tag cpp-build-env \
    --rm \
    .
