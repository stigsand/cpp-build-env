FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Use pipefail to catch errors in pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install build tools and dependencies
# hadolint ignore=DL3008
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

# Install Conan and set up a non-root user for building
# Note: --trusted-host flags are used to bypass SSL verification in restricted environments
# In production, ensure SSL certificates are properly configured
RUN pip3 install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org "conan>=2.0.0" \
    && useradd -m -s /bin/bash builder

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER builder

# Set default command
CMD ["/bin/bash"]
