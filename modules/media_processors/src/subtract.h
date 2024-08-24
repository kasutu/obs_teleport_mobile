#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

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

// A very short-lived native function.
FFI_PLUGIN_EXPORT intptr_t subtract(intptr_t a, intptr_t b);

// A longer lived native function, which occupies the thread calling it.
FFI_PLUGIN_EXPORT intptr_t subtract_long_running(intptr_t a, intptr_t b);

