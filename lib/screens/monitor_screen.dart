import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:obs_teleport_mobile/models/settings_model.dart';
import 'package:obs_teleport_mobile/services/camera_service.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  bool? _wasTeleporting; // To track the previous state

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await CameraService.instance.initializeController();
      setState(() {});
    } catch (e) {
      Logger.error('Camera initialization error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context, listen: true);

    // Check if the camera is not initialized
    if (!CameraService.instance.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Camera is not initialized'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text('Initialize Camera'),
            ),
          ],
        ),
      );
    }

    // Set camera settings based on the current settings model
    CameraService.instance.setInstanceSettings(
      const CameraDescription(
        name: 'Main Cam',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
      settings.cameraResolutionPreset,
      settings.cameraEnableAudio,
    );

    // Compare the previous state with the current state
    if (_wasTeleporting != settings.isTeleporting) {
      if (settings.isTeleporting) {
        Logger.info('Starting image stream');
        CameraService.instance.startImageStreamWithLogging();
      } else {
        Logger.info('Stopping image stream');
        CameraService.instance.stopImageStreamSafely();
      }

      // Update the previous state
      _wasTeleporting = settings.isTeleporting;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: CameraService.instance.value.aspectRatio,
                    child: CameraPreview(CameraService.instance),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
