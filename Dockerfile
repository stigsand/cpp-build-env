# Use recent Ubuntu LTS as base
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Install basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    wget \
    software-properties-common \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Add Kitware APT repository for latest CMake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null

# Add LLVM APT repository for latest Clang
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && echo "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/llvm.list >/dev/null

# Update package list and install build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    # Additional useful tools
    git \
    make \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Conan
RUN pip3 install --no-cache-dir conan

# Set up a non-root user for building
RUN useradd -m -s /bin/bash builder

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER builder

# Set default command
CMD ["/bin/bash"]
