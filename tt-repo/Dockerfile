# syntax=docker/dockerfile:1
FROM ubuntu:24.04

LABEL maintainer="Your Name"
LABEL description="C++ build environment with GCC, Clang, CMake, Conan, Ninja, and Mold"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies and tools
RUN apt-get update && apt-get install -y \
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
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null

# Add LLVM APT repository for Clang
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor - | tee /usr/share/keyrings/llvm-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/llvm.list >/dev/null

# Install GCC, Clang, CMake, and Ninja from repositories
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    clang \
    clang-format \
    clang-tidy \
    lld \
    lldb \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Install Python and pip for Conan
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Conan package manager
RUN pip3 install --no-cache-dir --break-system-packages conan

# Install Mold linker
RUN apt-get update && apt-get install -y \
    mold \
    && rm -rf /var/lib/apt/lists/*

# Verify installations
RUN gcc --version && \
    g++ --version && \
    clang --version && \
    cmake --version && \
    ninja --version && \
    conan --version && \
    mold --version

# Set up environment
ENV CC=gcc
ENV CXX=g++

WORKDIR /workspace

CMD ["/bin/bash"]
