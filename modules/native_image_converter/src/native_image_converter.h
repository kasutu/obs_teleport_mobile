#ifndef NATIVE_IMAGE_CONVERTER_H_
#define NATIVE_IMAGE_CONVERTER_H_

#include <stdint.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

// A function for YUV420 to RGBA conversion.
//
// This function converts YUV420 formatted image data to RGBA format.
// It takes pointers to the YUV420 data and an allocated RGBA buffer,
// along with the image width and height.
FFI_PLUGIN_EXPORT void yuv420_to_rgba(uint8_t* yuvData, uint8_t* rgbaData, int width, int height);

#endif  // NATIVE_IMAGE_CONVERTER_H_
