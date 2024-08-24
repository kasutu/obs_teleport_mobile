import 'dart:typed_data';
import 'dart:convert';

import 'package:obs_teleport_mobile/global/types.dart';
import 'package:obs_teleport_mobile/obs_teleport/pool.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

class Packet {
  Header header;
  ImageHeader imageHeader;
  WaveHeader waveHeader;
  Uint8List buffer;
  bool isAudio;
  bool isDoneProcessing;
  int jpegQuality;
  dynamic imageData; // Placeholder for image data
  ByteBuffer imageBuffer;

  Packet({
    required this.header,
    required this.imageHeader,
    required this.waveHeader,
    required this.buffer,
    required this.isAudio,
    required this.isDoneProcessing,
    required this.jpegQuality,
    required this.imageData,
    required this.imageBuffer,
  });

  void convertToJPEG(Pool bufferPool) {
    // Dummy implementation for E2E test
    // Use a logging framework instead of print
    Logger.info('Converting to JPEG with quality $jpegQuality');
    buffer = Uint8List.fromList(utf8.encode('JPEG data'));
  }

  void convertFromJPEG(Pool bufferPool) {
    // Use a logging framework instead of print
    Logger.info('Converting from JPEG');
    imageData = 'Decoded JPEG image';
  }

  void convertToImage(int width, int height, int format, List<Uint8List> data) {
    // Dummy implementation for E2E test
    // Use a logging framework instead of print
    Logger.info('Converting to Image with format $format');
    imageData = 'Converted image';
  }

  void convertToWAVE(
      AudioOutputInfo audioInfo, int frameCount, List<Uint8List> data) {
    // Dummy implementation for E2E test
    // Use a logging framework instead of print
    Logger.info('Converting to WAVE with format ${audioInfo.format}');
    buffer = Uint8List.fromList(utf8.encode('WAVE data'));
  }
}
