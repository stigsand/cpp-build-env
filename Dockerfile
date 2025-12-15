# syntax=docker/dockerfile:1
FROM ubuntu:25.10

# ToDo - from tt - check out
LABEL maintainer="Stig Sandnes <stig_sandnes@hotmail.com>" \
    description="C++ build environment with GCC, Clang, CMake, Conan, Ninja, and Mold"

# Avoid interactive prompts during package installation - ToDo - from tt - check out
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Use pipefail to catch errors in pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install basic dependencies and tools
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --yes --no-install-recommends \
    wget \
    gnupg \
    gpg \
    software-properties-common \
    ca-certificates \
    lsb-release \
    curl \
    git \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN \
    # Add Kitware APT repository for latest CMake
    wget --no-verbose -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
        | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
        && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main" \
        | tee /etc/apt/sources.list.d/kitware.list >/dev/null \
    # Add LLVM APT repository for Clang
    && wget --no-verbose -O - https://apt.llvm.org/llvm-snapshot.gpg.key \
        | gpg --dearmor - | tee /usr/share/keyrings/llvm-archive-keyring.gpg >/dev/null \
        && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-21 main" \
        | tee /etc/apt/sources.list.d/llvm.list >/dev/null \
    # Add Ubuntu Toolchain PPA for latest GCC
    && add-apt-repository --yes --no-update ppa:ubuntu-toolchain-r/ppa

# Install build tools and dependencies
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --yes --no-install-recommends \
    # GCC
    gcc-15 \
    g++-15 \
    # Clang/LLVM
    clang-21 \
    clang-tools-21 \
    clang-format-21 \
    clangd-21 \
    clang-tidy-21 \
    libc++-21-dev \
    libc++abi-21-dev \
    # CMake
    cmake \
    # Ninja
    ninja-build \
    # Mold
    mold \
    # Python for Conan
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    # Additional development tools
    git \
    make \
    pkg-config \
    ccache \
    valgrind \
    gdb \
    && rm -rf /var/lib/apt/lists/* \
    # strace
    && update-alternatives \
        --install /usr/bin/gcc gcc /usr/bin/gcc-15 15 \
        --slave /usr/bin/g++ g++ /usr/bin/g++-15 \
        --slave /usr/bin/gcov gcov /usr/bin/gcov-15 \
    && update-alternatives \
        --install /usr/bin/clang clang /usr/bin/clang-21 21 \
        --slave /usr/bin/clang++ clang++ /usr/bin/clang++-21 \
        --slave /usr/bin/clangd clangd /usr/bin/clangd-21 \
        --slave /usr/bin/clang-format clang-format /usr/bin/clang-format-21 \
        --slave /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-21 \
        --slave /usr/bin/run-clang-tidy run-clang-tidy /usr/bin/run-clang-tidy-21

# Install Conan
RUN pipx install conan==2.24.0 && pipx ensurepath && source ~/.bashrc

# Set up environment  - ????
ENV CC=gcc
ENV CXX=g++

# Set working directory
WORKDIR /workspace

# Switch to non-root user
# USER builder

# Verify installations
RUN gcc --version && \
    g++ --version && \
    clang --version && \
    cmake --version && \
    ninja --version && \
    mold --version

# Set default command
CMD ["/bin/bash"]
