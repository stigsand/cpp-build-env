#!/usr/bin/env bash

# Assumes logged in to the target Docker registry.

set -e

if [ -z "${1}" ]; then
    echo "Provide Docker repository name:tag as argument"
    exit 1
fi

IMAGE_NAME="${1}"
docker image tag cpp-build-env "${IMAGE_NAME}"
docker image push "${IMAGE_NAME}"
