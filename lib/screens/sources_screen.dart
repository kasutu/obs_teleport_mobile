// File: lib/screens/composition_screen.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:obs_teleport_mobile/widgets/device_dropdown.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({super.key});

  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  late List<CameraDescription> cameras;
  late List<String> videoDeviceList;
  late CameraDescription selectedCamera;
  final List<String> audioDeviceList = [
    'Audio Device 1',
    'Audio Device 2',
    'Audio Device 3',
    'Audio Device 4'
  ];

  @override
  void initState() {
    super.initState();
    loadCameras();
  }

  Future<void> loadCameras() async {
    cameras =
        await availableCameras(); // Use availableCameras() to get the list of cameras
    if (cameras.isNotEmpty) {
      selectedCamera = cameras.first;
    }
    videoDeviceList =
        cameras.map((e) => '${e.name} ${e.lensDirection.name}').toList();
    setState(() {});
  }

  void handleVideoDeviceSelected(int value) {
    setState(() {
      selectedCamera = cameras[value];
    });
  }

  void handleAudioDeviceSelected(int value) {
    // Handle audio input device selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sources'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DeviceDropdown(
              labelText: 'Video Source',
              deviceList: videoDeviceList,
              onSelected: handleVideoDeviceSelected,
            ),
            const SizedBox(height: 16.0),
            DeviceDropdown(
              labelText: 'Audio Source',
              deviceList: audioDeviceList,
              onSelected: handleAudioDeviceSelected,
            ),
          ],
        ),
      ),
    );
  }
}
