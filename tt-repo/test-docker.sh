#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

IMAGE_NAME="${IMAGE_NAME:-cpp-builder}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

echo -e "${BLUE}Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

echo -e "\n${BLUE}Testing Docker image with C++ project${NC}"

# Test with GCC
echo -e "\n${GREEN}Test 1: Building with GCC and Ninja${NC}"
docker run --rm -v "$(pwd)/test-project:/workspace" "${IMAGE_NAME}:${IMAGE_TAG}" bash -c "
    set -e
    cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
    cmake --build build
    ./build/test_app
"

# Test with Clang
echo -e "\n${GREEN}Test 2: Building with Clang and Ninja${NC}"
docker run --rm -v "$(pwd)/test-project:/workspace" "${IMAGE_NAME}:${IMAGE_TAG}" bash -c "
    set -e
    export CC=clang
    export CXX=clang++
    cmake -B build-clang -G Ninja -DCMAKE_BUILD_TYPE=Release
    cmake --build build-clang
    ./build-clang/test_app
"

# Test with Mold linker
echo -e "\n${GREEN}Test 3: Building with GCC and Mold linker${NC}"
docker run --rm -v "$(pwd)/test-project:/workspace" "${IMAGE_NAME}:${IMAGE_TAG}" bash -c "
    set -e
    cmake -B build-mold -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS='-fuse-ld=mold'
    cmake --build build-mold
    ./build-mold/test_app
"

# Test Conan
echo -e "\n${GREEN}Test 4: Testing Conan integration${NC}"
docker run --rm -v "$(pwd)/test-project:/workspace" "${IMAGE_NAME}:${IMAGE_TAG}" bash -c "
    set -e
    conan profile detect --force
    conan install . --output-folder=build-conan --build=missing
    cmake -B build-conan -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=build-conan/conan_toolchain.cmake
    cmake --build build-conan
    ./build-conan/test_app
"

echo -e "\n${GREEN}All tests passed successfully!${NC}"
