#!/usr/bin/env bash

set -e

docker container run --rm -i -v "$(pwd)":/src cpp-build-env /src/test/test.sh
