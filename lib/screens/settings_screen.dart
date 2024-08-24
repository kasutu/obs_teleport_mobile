// File: lib/screens/settings_screen.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';
import 'package:camera/camera.dart';
import 'package:obs_teleport_mobile/widgets/peer_info_form.dart';
import 'package:provider/provider.dart';
import 'package:obs_teleport_mobile/models/settings_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  late SettingsModel settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settings = Provider.of<SettingsModel>(context, listen: true);

    _identifierController.text = settings.announceTeleportPeerName;
    _portController.text = settings.announceTeleportPeerPort.toString();
    _qualityController.text = settings.announceTeleportPeerQuality.toString();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _portController.dispose();
    _qualityController.dispose();
    Logger.close();
    super.dispose();
  }

  void _onIdentifierChanged(String value) {
    Logger.info('Identifier changed: $value');
    settings.announceTeleportPeerName = value;
  }

  void _onPortChanged(int value) {
    Logger.info('Port changed: $value');
    settings.announceTeleportPeerPort = value;
  }

  void _onQualityChanged(double value) {
    Logger.info('Quality changed: $value');
    settings.announceTeleportPeerQuality = value;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PeerInfoForm(
                        identifierController: _identifierController,
                        portController: _portController,
                        qualityController: _qualityController,
                        onIdentifierChanged: _onIdentifierChanged,
                        onPortChanged: (value) {
                          _onPortChanged(value);
                        },
                        onQualityChanged: _onQualityChanged,
                      ),
                      _buildCameraSettings(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraSettings() {
    return Consumer<SettingsModel>(
      builder: (context, settingsModel, child) {
        return Column(
          children: [
            ListTile(
              title: const Text('Resolution'),
              trailing: SizedBox(
                width: 150, // Adjust the width as needed
                child: DropdownButton<ResolutionPreset>(
                  value: settingsModel.cameraResolutionPreset,
                  onChanged: (ResolutionPreset? newValue) {
                    if (newValue != null) {
                      settingsModel.cameraResolutionPreset = newValue;
                    }
                  },
                  items: ResolutionPreset.values.map((ResolutionPreset value) {
                    return DropdownMenuItem<ResolutionPreset>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
            ),
            ListTile(
              title: const Text('Enable Audio'),
              trailing: Switch(
                value: settingsModel.cameraEnableAudio,
                onChanged: (bool value) {
                  settingsModel.cameraEnableAudio = value;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
