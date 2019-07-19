#!/usr/bin/env bash

set -e

GIT_REV="${GIT_REV:-$(git rev-parse --short=8 HEAD)}"

docker image build \
    --file Dockerfile \
    --build-arg GIT_REV="${GIT_REV}" \
    --tag cpp-build-env \
    --rm \
    .
