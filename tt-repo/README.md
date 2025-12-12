# C++ Builder Docker Image

A Docker image for building C++ projects with modern tools and compilers.

## Included Tools

- **Ubuntu 24.04** - Base image
- **GCC** - GNU Compiler Collection (latest)
- **Clang** - LLVM Clang compiler (latest)
- **CMake** - Build system generator (from Kitware APT repository)
- **Conan** - C++ package manager
- **Ninja** - Fast build system
- **Mold** - Modern, high-performance linker

## Usage

### Build the image

```bash
docker build -t cpp-builder:latest .
```

### Run a build

```bash
docker run --rm -v $(pwd):/workspace cpp-builder:latest bash -c "cmake -B build -G Ninja && cmake --build build"
```

### Interactive shell

```bash
docker run --rm -it -v $(pwd):/workspace cpp-builder:latest
```

## Testing

Run the test script to verify the image works correctly:

```bash
chmod +x test-docker.sh
./test-docker.sh
```

## GitHub Actions

The repository includes a workflow that:
- Builds the Docker image
- Lints the Dockerfile with Hadolint
- Tests the image with a sample C++ project
- Publishes to Docker Hub (on push to main)

### Required Secrets

Configure these secrets in your GitHub repository:
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Your Docker Hub access token
