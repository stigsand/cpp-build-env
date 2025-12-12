# cpp-build-env

A Docker-based build environment for C++ projects

## Features

This Docker image includes:

- **Ubuntu 22.04 LTS** as the base image
- **GCC** - Latest GNU Compiler Collection
- **Clang** - Latest LLVM C/C++ compiler from apt.llvm.org
- **CMake** - Latest version from Kitware's official repository
- **Ninja** - Fast build system
- **Conan** - C++ package manager
- **Mold** - Modern, high-performance linker

## Usage

Pull the image from Docker Hub:

```bash
docker pull stigsand/cpp-build-env:latest
```

Run a container:

```bash
docker run -it --rm -v $(pwd):/workspace stigsand/cpp-build-env:latest
```

Build a C++ project:

```bash
# Inside the container
cd /workspace
mkdir build && cd build
cmake -G Ninja ..
ninja
```

## Building Locally

```bash
docker build -t cpp-build-env .
```

## Testing

The image is tested with a sample C++ project using multiple compilers and linkers:

```bash
docker run --rm -v $(pwd)/test:/workspace cpp-build-env bash -c "chmod +x /workspace/test-build.sh && /workspace/test-build.sh"
```

## CI/CD

The Docker image is automatically built, tested, and published to Docker Hub via GitHub Actions on every push to the main branch.
