IMAGE_NAME="${IMAGE_NAME:-cpp-build-env}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

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
