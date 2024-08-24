import 'package:camera/camera.dart';
import 'package:obs_teleport_mobile/interop/camera_image_converter.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

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
    startImageStream((CameraImage image) {
      Logger.info('[IMAGE DATA] ${image.format.group.name}');

      // CameraImageConverter.convertYUV420ToJPEG(image).then((image) {
      //   Logger.info('Image converted successfully');
      // }).catchError((e) {
      //   Logger.error('Error converting image: $e');
      // });
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
