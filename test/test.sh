#!/usr/bin/env bash

set -e

echo "Running test script inside Docker container - success"

conan install \
    --install-folder tmp \
    --generator cmake \
    Catch2/2.9.1@catchorg/stable
