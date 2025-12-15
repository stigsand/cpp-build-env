cmake_minimum_required(VERSION 4.2)
project(test_project CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(test_app main.cpp)
