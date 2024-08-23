// File: monitor_screen.dart

// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:obs_teleport_mobile/camera/video_converter.dart';
import 'package:obs_teleport_mobile/main.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

/// CameraApp is the Main Application.
class MonitorScreen extends StatefulWidget {
  /// Default Constructor
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      builtInCameras[0],
      ResolutionPreset.low,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    controller.prepareForVideoRecording();

    controller.startImageStream((CameraImage image) async {
      // Convert the JPEG to a Uint8List
      // TeleportImage? teleportImage = await yuvToRgb(image);

      // Display the Uint8List
      Logger.info('[TRANSMITTING]');

      // print('[IMAGE DATA] ${image.format.group.name}');
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: CameraPreview(controller)),
          ],
        ),
      ),
    );
  }
}
