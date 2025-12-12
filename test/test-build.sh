#!/bin/bash

set -e

echo "=== Testing C++ Build Environment ==="

# Display versions of installed tools
echo ""
echo "=== Tool Versions ==="
echo "GCC: $(gcc --version | head -n1)"
echo "G++: $(g++ --version | head -n1)"
echo "Clang: $(clang --version | head -n1)"
echo "CMake: $(cmake --version | head -n1)"
echo "Ninja: $(ninja --version)"
echo "Conan: $(conan --version)"
echo "Mold: $(mold --version)"

cmake \
    -G Ninja \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
    -DCMAKE_BUILD_TYPE=Release \
    -B build/clang \
    --fresh
cmake --build build/clang
build/clang/test_app | grep -qFx "26"

cmake \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_COMPILER=g++ \
    -B build/gcc \
    --fresh
cmake --build build/gcc
./build/gcc/test_app | grep -qFx '[1, 2, 3, 4]'

conan install \
    --requires ctre/3.10.0 \
    --build=missing \
    --output-folder=build/conan

exit 0

# Create build directory
echo ""
echo "=== Building Test Project ==="
mkdir -p build
cd build


# Clean and rebuild with Clang
echo ""
echo "Building with Clang and Ninja..."
rm -rf ./*
cmake -G Ninja -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release ..
ninja

# Run the test application again
echo ""
echo "Running test application (Clang build)..."
./test_app

# Test with Mold linker
echo ""
echo "Building with Mold linker..."
rm -rf ./*
cmake -G Ninja -DCMAKE_CXX_COMPILER=g++ -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=mold" -DCMAKE_BUILD_TYPE=Release ..
ninja

echo ""
echo "Running test application (Mold linker build)..."
./test_app

echo ""
echo "=== All Tests Passed! ==="
