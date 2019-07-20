#!/usr/bin/env bash

set -e

echo "Running test script inside Docker container..."

# Conan 1.17.0
[[ "$(conan --version)" =~ "1.17.1" ]] || echo Oops

BUILD_DIR="$(mktemp --directory --tmpdir)"
echo Build dir: ${BUILD_DIR}
conan install \
    --install-folder "${BUILD_DIR}" \
    --generator cmake \
    Catch2/2.9.1@catchorg/stable
ls -la "${BUILD_DIR}"
echo "... success"
