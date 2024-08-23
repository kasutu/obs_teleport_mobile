// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';
import 'package:obs_teleport_mobile/widgets/peer_info_form.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPeerInfoForm(),
          ],
        ),
      ),
    );
  }

  void _disposeResources() {
    _textEditingController.dispose();
    Logger.close();
  }

  Widget _buildPeerInfoForm() {
    return const PeerInfoForm();
  }
}
