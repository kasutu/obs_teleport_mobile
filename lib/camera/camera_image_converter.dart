import 'dart:typed_data';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;

class CameraImageConverter {
  static Future<Uint8List> convertInIsolate(
      Uint8List yuvData, int width, int height) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(
        _isolateEntry, [responsePort.sendPort, yuvData, width, height]);
    return await responsePort.first as Uint8List;
  }

  static void _isolateEntry(List<dynamic> args) {
    final SendPort sendPort = args[0];
    final Uint8List yuvData = args[1];
    final int width = args[2];
    final int height = args[3];

    final rgbaData = _convertYuv420ToRgba8888(yuvData, width, height);
    sendPort.send(rgbaData);
  }

  static Uint8List _convertYuv420ToRgba8888(
      Uint8List yuvData, int width, int height) {
    final int frameSize = width * height;
    final Uint8List rgbaData = Uint8List(width * height * 4);

    int yIndex = 0;
    int uIndex = frameSize;
    int vIndex = frameSize + (frameSize ~/ 4);

    for (int j = 0; j < height; j++) {
      for (int i = 0; i < width; i++) {
        final y = yuvData[yIndex++] & 0xff;
        final u = yuvData[uIndex + (j >> 1) * (width >> 1) + (i >> 1)] & 0xff;
        final v = yuvData[vIndex + (j >> 1) * (width >> 1) + (i >> 1)] & 0xff;

        final r = _clamp(y + (1.370705 * (v - 128)));
        final g = _clamp(y - (0.337633 * (u - 128)) - (0.698001 * (v - 128)));
        final b = _clamp(y + (1.732446 * (u - 128)));

        final rgbaIndex = (j * width + i) * 4;
        rgbaData[rgbaIndex] = r;
        rgbaData[rgbaIndex + 1] = g;
        rgbaData[rgbaIndex + 2] = b;
        rgbaData[rgbaIndex + 3] = 255;
      }
    }

    return rgbaData;
  }

  static int _clamp(double value) {
    return value.clamp(0, 255).toInt();
  }

  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static image_lib.Image? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return _convertYUV420ToImage(cameraImage);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return _convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  static image_lib.Image _convertBGRA8888ToImage(CameraImage image) {
    return image_lib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: image_lib.ChannelOrder.bgra,
    );
  }

  static image_lib.Image _convertYUV420ToImage(CameraImage image) {
    return image_lib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: image_lib.ChannelOrder.rgb,
    );
  }
}
