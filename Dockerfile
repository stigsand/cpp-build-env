# syntax=docker/dockerfile:1
FROM ubuntu:24.04

# ToDo - from tt - check out
LABEL maintainer="Your Name"
LABEL description="C++ build environment with GCC, Clang, CMake, Conan, Ninja, and Mold"

# Avoid interactive prompts (during package installation? - ToDo - from tt - check out)
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Use pipefail to catch errors in pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install basic dependencies and tools
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --yes --no-install-recommends \
    wget \
    gnupg \
    software-properties-common \
    ca-certificates \
    lsb-release \
    curl \
    git \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Add Kitware APT repository for CMake
RUN wget --no-verbose -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null

# Add LLVM APT repository for Clang
RUN wget --no-verbose -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor - | tee /usr/share/keyrings/llvm-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/llvm.list >/dev/null

# Install build tools and dependencies
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --yes --no-install-recommends \
    # GCC
    gcc \
    g++ \
    # Clang
    clang \
    clang-tools \
    clang-format \
    clang-tidy \
    libc++-dev \
    libc++abi-dev \
    # CMake
    cmake \
    # Ninja
    ninja-build \
    # Mold linker
    mold \
    # Python for Conan
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    # Additional useful tools
    git \
    make \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Conan and set up a non-root user for building
# Note: --trusted-host flags are used to bypass SSL verification in restricted environments
# In production, ensure SSL certificates are properly configured
RUN pipx ensurepath && pipx install "conan>=2.0.0" \
    && useradd -m builder

# Alternative from tt
# Install Conan package manager
#RUN pip3 install --no-cache-dir --break-system-packages conan
RUN echo "Path: $PATH"




# Set up environment  - ????
ENV CC=gcc
ENV CXX=g++

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER builder
RUN echo "Path: $PATH" && pipx ensurepath

# Verify installations
RUN gcc --version && \
    g++ --version && \
    clang --version && \
    cmake --version && \
    ninja --version && \
    mold --version

# Set default command
CMD ["/bin/bash"]
