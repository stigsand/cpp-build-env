#!/bin/bash
set -e

docker container run --rm -i hadolint/hadolint:v2.14.0 < Dockerfile
docker image build -t cpp-build-env:test .
docker container run --rm -ti -v $(pwd)/test:/workspace cpp-build-env:test ./test-build.sh
