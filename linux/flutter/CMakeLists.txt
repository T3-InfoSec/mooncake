# CMake configuration for the Mooncake plugin.
cmake_minimum_required(VERSION 3.10)
project(mooncake_plugin LANGUAGES CXX)

# Include Flutter's CMake configuration.
include("${CMAKE_CURRENT_SOURCE_DIR}/flutter/ephemeral/generated_config.cmake")

add_library(mooncake_plugin SHARED
  "src/mooncake_plugin.cc"
)

set_target_properties(mooncake_plugin PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED YES
  CXX_EXTENSIONS NO
)

target_include_directories(mooncake_plugin PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(mooncake_plugin PRIVATE flutter)
