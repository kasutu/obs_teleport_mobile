# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(media_processors_library VERSION 0.0.1 LANGUAGES C)

# Add subtract.c to the list of source files
set(SOURCES
    media_processors.c
    subtract.c
)

add_library(media_processors SHARED ${SOURCES})

set_target_properties(media_processors PROPERTIES
  PUBLIC_HEADER media_processors.h
  OUTPUT_NAME "media_processors"
)

target_compile_definitions(media_processors PUBLIC DART_SHARED_LIB)