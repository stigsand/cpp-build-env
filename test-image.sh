#!/usr/bin/env bash

set -e

#docker container run --rm -i hadolint/hadolint:v1.17.1 hadolint \
#    --ignore DL3008 \
#    --ignore DL3009 \
#    - \
#    < Dockerfile
docker container run --rm -i -v "$(pwd)":/src cpp-build-env /src/test/test.sh
