// ignore_for_file: library_prefixes

import 'dart:ffi';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart' as path;

typedef TeleportImage = imageLib.Image;

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static TeleportImage? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420ToImage(cameraImage);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  static TeleportImage convertBGRA8888ToImage(CameraImage image) {
    return imageLib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: imageLib.ChannelOrder.bgra,
    );
  }

  static TeleportImage convertNV21ToImage(CameraImage image) {
    return imageLib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes.first.bytes.buffer,
      order: imageLib.ChannelOrder.bgra,
    );
  }

  static TeleportImage convertYUV420ToImage(CameraImage image) {
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel ?? 0;

    final img = imageLib.Image(width: image.width, height: image.height);
    final imgBytes = img.getBytes();

    for (var i = 0, len = imgBytes.length; i < len; i += 4) {
      final x = (i ~/ 4) % img.width;
      final y = (i ~/ 4) ~/ img.width;

      final uvIndex =
          uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
      final index = y * uvRowStride + x;

      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];

      imgBytes[i] = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255).toInt();
      imgBytes[i + 1] =
          (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255)
              .toInt();
      imgBytes[i + 2] =
          (yp + up * 1814 / 1024 - 227).round().clamp(0, 255).toInt();
      imgBytes[i + 3] = 255; // Alpha channel
    }

    return img;
  }
}

TeleportImage? processCameraImage(CameraImage cameraImage) {
  TeleportImage? image = ImageUtils.convertCameraImage(cameraImage);

  if (Platform.isIOS) {
    // ios, default camera image is portrait view
    // rotate 270 to the view that top is on the left, bottom is on the right
    // image ^4.0.17 error here
    image = imageLib.copyRotate(image!, angle: 270);
  }

  return image;
  // processImage(inputImage);
}

// Define the function signature in C terms
typedef NativeYuvToRgbFunc = ffi.Pointer<ffi.Uint32> Function(
    ffi.Pointer<ffi.Uint8> yPlane,
    ffi.Pointer<ffi.Uint8> uPlane,
    ffi.Pointer<ffi.Uint8> vPlane,
    ffi.Int32 uvRowStride,
    ffi.Int32 uvPixelStride,
    ffi.Int32 width,
    ffi.Int32 height);

// Define the function signature in Dart terms
typedef YuvToRgbFunc = ffi.Pointer<ffi.Uint32> Function(
    ffi.Pointer<ffi.Uint8> yPlane,
    ffi.Pointer<ffi.Uint8> uPlane,
    ffi.Pointer<ffi.Uint8> vPlane,
    int uvRowStride,
    int uvPixelStride,
    int width,
    int height);

Future<TeleportImage> yuvToRgb(CameraImage cameraImage) async {
  // Allocate memory for the 3 planes of the image
  Pointer<Uint8> p = calloc.allocate(cameraImage.planes[0].bytes.length);
  Pointer<Uint8> p1 = calloc.allocate(cameraImage.planes[1].bytes.length);
  Pointer<Uint8> p2 = calloc.allocate(cameraImage.planes[2].bytes.length);

  // Assign the planes data to the pointers of the image
  Uint8List pointerList = p.asTypedList(cameraImage.planes[0].bytes.length);
  Uint8List pointerList1 = p1.asTypedList(cameraImage.planes[1].bytes.length);
  Uint8List pointerList2 = p2.asTypedList(cameraImage.planes[2].bytes.length);
  pointerList.setRange(
      0, cameraImage.planes[0].bytes.length, cameraImage.planes[0].bytes);
  pointerList1.setRange(
      0, cameraImage.planes[1].bytes.length, cameraImage.planes[1].bytes);
  pointerList2.setRange(
      0, cameraImage.planes[2].bytes.length, cameraImage.planes[2].bytes);

  // android\app\src\main\jniLibs\yuvToRgb.so
  final DynamicLibrary yuvToRgbLib = DynamicLibrary.open('yuvToRgb.so');

  // Look up the function
  final YuvToRgbFunc yuvToRgb = yuvToRgbLib
      .lookupFunction<NativeYuvToRgbFunc, YuvToRgbFunc>('yuv_to_rgb');

// Call the convertImage function and convert the YUV to RGB
  Pointer<Uint32> imgP = yuvToRgb(
    p,
    p1,
    p2,
    cameraImage.planes[1].bytesPerRow,
    cameraImage.planes[1].bytesPerPixel!,
    cameraImage.width,
    cameraImage.height,
  );

  // Get the pointer of the data returned from the function to a List
  List<int> imgData =
      imgP.asTypedList((cameraImage.width * cameraImage.height));

  // Generate image from the converted data
  imageLib.Image img = imageLib.Image.fromBytes(
    height: cameraImage.height,
    width: cameraImage.width,
    bytes: Uint8List.fromList(imgData).buffer,
  );

  // Free the memory space allocated
  // from the planes and the converted data
  calloc.free(p);
  calloc.free(p1);
  calloc.free(p2);
  calloc.free(imgP);

  return img;
}

// use JNIgen to interop with native java code in android
// and access the camera 2 or cameraX APIs