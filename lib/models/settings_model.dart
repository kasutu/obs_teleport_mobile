// File: lib/models/settings_model.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  String _announceTeleportPeerName = 'Mobile Node';
  double _announceTeleportPeerQuality = 90.0; // Changed from int to double
  int _announceTeleportPeerPort = 0; // Add a private field for port
  ResolutionPreset _cameraResolutionPreset = ResolutionPreset.high;
  bool _cameraEnableAudio = true;
  bool _isTeleporting = false;

  String get announceTeleportPeerName => _announceTeleportPeerName;

  set announceTeleportPeerName(String value) {
    _announceTeleportPeerName = value;
    notifyListeners();
  }

  double get announceTeleportPeerQuality =>
      _announceTeleportPeerQuality; // Changed return type to double

  set announceTeleportPeerQuality(double value) {
    // Changed parameter type to double
    _announceTeleportPeerQuality = value;
    notifyListeners();
  }

  int get announceTeleportPeerPort => _announceTeleportPeerPort;

  set announceTeleportPeerPort(int value) {
    _announceTeleportPeerPort = value;
    notifyListeners();
  }

  ResolutionPreset get cameraResolutionPreset => _cameraResolutionPreset;

  set cameraResolutionPreset(ResolutionPreset value) {
    _cameraResolutionPreset = value;
    notifyListeners();
  }

  bool get cameraEnableAudio => _cameraEnableAudio;

  set cameraEnableAudio(bool value) {
    _cameraEnableAudio = value;
    notifyListeners();
  }

  bool get isTeleporting => _isTeleporting;

  set isTeleporting(bool value) {
    _isTeleporting = value;
    notifyListeners();
  }
}
