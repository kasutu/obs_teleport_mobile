// File: monitor_screen.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/main.dart';

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
    controller = CameraController(builtInCameras[0], ResolutionPreset.max,
        enableAudio: true);

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

    // // stream of image sequence
    // controller.startVideoRecording(onAvailable: (image) {
    //   print(image.format.raw);
    //   print(image.format);
    //   print(image.format.group.name);
    // });

    return Scaffold(
      body: SafeArea(
        child: CameraPreview(controller),
      ),
    );
  }
}
