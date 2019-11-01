cmake_minimum_required(VERSION 3.5)

project (eigen)
add_definitions(-DLH3_EIGENG_MAIN)
add_executable(eigen ../../source/feigen.c)
