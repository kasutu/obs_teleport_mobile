import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/widgets/device_dropdown.dart';

class CompositionScreen extends StatelessWidget {
  CompositionScreen({super.key});

  final List<String> videoDeviceList = [
    'Video Device 1',
    'Video Device 2',
    'Video Device 3',
    'Video Device 4'
  ];
  final List<String> audioDeviceList = [
    'Audio Device 1',
    'Audio Device 2',
    'Audio Device 3',
    'Audio Device 4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Composition'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200, // Adjust the height as needed
              color: Colors.grey, // Placeholder color
              // Add your video preview widget here
            ),
            const SizedBox(height: 16.0),
            DeviceDropdown(
              labelText: 'Video Input Device',
              deviceList: videoDeviceList, // replace with your actual list
              onSelected: (value) {
                // Handle video input device selection
              },
            ),
            const SizedBox(height: 16.0),
            DeviceDropdown(
              labelText: 'Audio Input Device',
              deviceList: audioDeviceList, // replace with your actual list
              onSelected: (value) {
                // Handle audio input device selection
              },
            ),
          ],
        ),
      ),
    );
  }
}
