#include "subtract.h"

// A very short-lived native function for subtraction.
FFI_PLUGIN_EXPORT intptr_t subtract(intptr_t a, intptr_t b) { return a - b; }

// A longer-lived native function for subtraction, which occupies the thread calling it.
FFI_PLUGIN_EXPORT intptr_t subtract_long_running(intptr_t a, intptr_t b) {
  // Simulate work.
#if _WIN32
  Sleep(5000);
#else
  usleep(5000 * 1000);
#endif
  return a - b;
}