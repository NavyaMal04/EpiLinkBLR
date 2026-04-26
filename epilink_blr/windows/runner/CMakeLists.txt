cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# The name of the executable to create.
set(BINARY_NAME "epilink_blr")

# Define the executable.
add_executable(${BINARY_NAME} WIN32
  "main.cpp"
  "resource.h"
  "runner.rc"
  "utils.cpp"
  "win32_window.cpp"
  "flutter_window.cpp"
  "../flutter/generated_plugin_registrant.cc"
  ${FLUTTER_MANAGED_SOURCES}
)

# Standard configuration.
apply_standard_settings(${BINARY_NAME})
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Include paths.
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/../flutter")

# Link libraries.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE dwmapi.lib)

# FORCE LINKING TO SYSTEM RUNTIMES TO FIX __std_find_trivial ERRORS
target_link_libraries(${BINARY_NAME} PRIVATE msvcrt.lib msvcprt.lib ucrt.lib vcruntime.lib)

# Flutter plugin integration.
# Note: we are not using the explicit flutter_setup_binaries here 
# as it was causing issues and is handled by the root project.
