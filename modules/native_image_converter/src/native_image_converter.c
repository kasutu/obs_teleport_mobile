#include "native_image_converter.h"
#include <stdint.h>

// Clamps the value to the 0-255 range
static inline uint8_t clamp(int32_t value) {
    if (value < 0) return 0;
    if (value > 255) return 255;
    return (uint8_t)value;
}

// A native function for YUV420 to RGBA conversion
FFI_PLUGIN_EXPORT void yuv420_to_rgba(uint8_t* yuvData, uint8_t* rgbaData, int width, int height) {
    int frameSize = width * height;
    int uIndex = frameSize;
    int vIndex = frameSize + (frameSize / 4);
    
    int yIndex = 0;
    int rgbaIndex = 0;

    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {
            int y = yuvData[yIndex] & 0xff;
            int u = yuvData[uIndex + (j / 2) * (width / 2) + (i / 2)] & 0xff;
            int v = yuvData[vIndex + (j / 2) * (width / 2) + (i / 2)] & 0xff;

            int r = y + (1.370705 * (v - 128));
            int g = y - (0.337633 * (u - 128)) - (0.698001 * (v - 128));
            int b = y + (1.732446 * (u - 128));

            rgbaData[rgbaIndex]     = clamp(r);
            rgbaData[rgbaIndex + 1] = clamp(g);
            rgbaData[rgbaIndex + 2] = clamp(b);
            rgbaData[rgbaIndex + 3] = 255; // Alpha channel
            
            yIndex++;
            rgbaIndex += 4;
        }
    }
}
