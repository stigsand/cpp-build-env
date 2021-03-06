#!/usr/bin/env bash

set -e

echo "Running test script inside container..."

# Conan 1.18.1
[[ "$(conan --version)" =~ 1\.18\.1 ]] || (>&2 echo "Conan version test failed" && false)
BUILD_DIR="$(mktemp --directory --tmpdir)"
conan install \
    --install-folder "${BUILD_DIR}" \
    --generator cmake \
    Catch2/2.9.1@catchorg/stable \
    > /dev/null

# GCC 9.1.0
[[ "$(g++ --version)" =~ 9\.1\.0 ]] || (>&2 echo "GCC version test failed" && false)
cat /root/.conan/remotes.json
