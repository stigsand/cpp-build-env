cmake_minimum_required(VERSION 3.20)
project(TestProject VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(test_app main.cpp)

# Enable warnings
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(test_app PRIVATE -Wall -Wextra -Wpedantic)
endif()

# Installation
install(TARGETS test_app DESTINATION bin)
