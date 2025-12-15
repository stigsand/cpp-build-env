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

set -e
export CC=clang
export CXX=clang++
cmake -B build-clang -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build-clang
./build-clang/test_app
./build-clang/test_app | grep -qFx "26"


exit 0

# Create build directory
echo ""
echo "=== Building Test Project ==="
mkdir -p build
cd build

# Build with GCC and Ninja
echo ""
echo "Building with GCC and Ninja..."
cmake -G Ninja -DCMAKE_CXX_COMPILER=g++ -DCMAKE_BUILD_TYPE=Release ..
ninja

# Run the test application
echo ""
echo "Running test application (GCC build)..."
./test_app

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
