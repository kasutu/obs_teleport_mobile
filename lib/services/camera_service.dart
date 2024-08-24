import 'package:camera/camera.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

import 'package:media_processors/media_processors.dart' as media_processors;

class CameraService extends CameraController {
  static final CameraService _instance = CameraService._internal();

  // Factory constructor to ensure singleton pattern
  factory CameraService({
    required CameraDescription cameraDescription,
    required ResolutionPreset resolutionPreset,
    bool enableAudio = false,
  }) {
    _instance.setInstanceSettings(
      cameraDescription,
      resolutionPreset,
      enableAudio,
    );
    return _instance;
  }

  // Private named constructor
  CameraService._internal()
      : super(
          const CameraDescription(
            name: '0', // the camera ID lol
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 0,
          ),
          ResolutionPreset.high,
        );

  // Static method to access the singleton instance
  static CameraService get instance => _instance;

  // Method to initialize the controller with specific parameters
  void setInstanceSettings(
    CameraDescription cameraDescription,
    ResolutionPreset resolutionPreset,
    bool enableAudio,
  ) {
    cameraDescription = cameraDescription;
    resolutionPreset = resolutionPreset;
    enableAudio = enableAudio;
  }

  // Asynchronous initialization method
  Future<void> initializeController() async {
    try {
      await initialize();
      await prepareForVideoRecording();
      Logger.info('Camera initialized with resolution: $resolutionPreset');
    } catch (e) {
      Logger.error('Camera initialization error: ${e.toString()}');
    }
  }

  // Start the image stream with logging
  void startImageStreamWithLogging() {
    startImageStream((CameraImage image) async {
      Logger.info('[IMAGE DATA] ${image.format.group.name}');

      // Example usage of media_processors functions
      int resultSum = media_processors.sum(5, 3);
      int resultSubtract = await media_processors.subtractAsync(5, 3);
      Logger.info('Sum result: $resultSum');
      Logger.info('Subtract result: $resultSubtract');
    });
  }

  // Stop the image stream safely
  void stopImageStreamSafely() {
    try {
      stopImageStream();
    } catch (e) {
      Logger.error('Error stopping image stream: $e');
    }
  }

  // Dispose of the controller with logging
  @override
  Future<void> dispose() async {
    try {
      await super.dispose();
      Logger.info('Camera controller disposed');
    } catch (e) {
      Logger.error('Error disposing camera controller: $e');
    }
  }
}
