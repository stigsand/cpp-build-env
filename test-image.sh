#!/usr/bin/env bash

set -e

source use-podman

# docker container run --rm -i hadolint/hadolint:v1.17.1 hadolint - < Dockerfile
docker container run --rm --tty \
    -v "$(pwd)":/mnt \
    koalaman/shellcheck:v0.6.0 \
    --shell=bash \
    --external-sources \
    build-image.sh test-image.sh test/test.sh push-image.sh \
    hooks/build hooks/test hooks/push
docker container run --rm -i -v "$(pwd)":/src cpp-build-env /src/test/test.sh
