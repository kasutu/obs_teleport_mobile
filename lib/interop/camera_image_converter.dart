import 'dart:ffi';
import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:image/image.dart' as image_lib;
import 'package:native_image_converter/native_image_converter.dart';

class CameraImageConverter {
  /// Converts a [CameraImage] in BGRA8888 format to [image_lib.Image] in RGB format
  static image_lib.Image convertBGRA8888ToImage(CameraImage image) {
    return image_lib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: image_lib.ChannelOrder.bgra,
    );
  }

  /// Converts a [CameraImage] in YUV420 format to [image_lib.Image] in RGB format
  static Future<image_lib.Image> convertYUV420ToImage(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;

    // Allocate memory for the YUV and RGBA data.
    final Pointer<Uint8> yuvPointer =
        malloc.allocate<Uint8>(image.planes[0].bytes.length);
    final Pointer<Uint8> rgbaPointer =
        malloc.allocate<Uint8>(width * height * 4);

    // Copy the YUV data into the allocated memory.
    yuvPointer
        .asTypedList(image.planes[0].bytes.length)
        .setAll(0, image.planes[0].bytes);

    // Perform the conversion using the native function.
    await convertYuv420ToRgbaAsync(yuvPointer, rgbaPointer, width, height);

    // Create an Image from the RGBA data.
    final image_lib.Image convertedImage = image_lib.Image.fromBytes(
      width: width,
      height: height,
      bytes: rgbaPointer.asTypedList(width * height * 4).buffer,
      order: image_lib.ChannelOrder.rgba,
    );

    // Free the allocated memory.
    malloc.free(yuvPointer);
    malloc.free(rgbaPointer);

    return convertedImage;
  }
}
