# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(native_image_converter_library VERSION 0.0.1 LANGUAGES C)

add_library(native_image_converter SHARED
  "native_image_converter.c"
)

set_target_properties(native_image_converter PROPERTIES
  PUBLIC_HEADER native_image_converter.h
  OUTPUT_NAME "native_image_converter"
)

target_compile_definitions(native_image_converter PUBLIC DART_SHARED_LIB)
