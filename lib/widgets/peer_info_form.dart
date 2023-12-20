// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

class PeerInfoForm extends StatefulWidget {
  const PeerInfoForm({super.key});

  @override
  _PeerInfoFormState createState() => _PeerInfoFormState();
}

class _PeerInfoFormState extends State<PeerInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _portController = TextEditingController();
  double _currentSliderValue = 90;

  Widget _buildIdentifierField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextFormField(
            controller: _identifierController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Identifier',
              helperText: 'Enter identifier (optional), default is Hostname',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextFormField(
            controller: _portController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Port',
              helperText: 'Enter port (optional), default is auto',
            ),
            keyboardType: TextInputType.number,
          ),
        )
      ],
    );
  }

  Widget _buildQualitySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quality'),
        Slider(
          value: _currentSliderValue,
          min: 1,
          max: 100,
          divisions: 100,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        Text('Current quality: ${_currentSliderValue.round()}'),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Logger.info('Identifier: ${_identifierController.text}');
            Logger.info('Port: ${_portController.text}');
            Logger.info('Quality: ${_currentSliderValue.round()}');
          }
        },
        child: const Text('Save'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildIdentifierField(),
            const SizedBox(height: 20),
            _buildPortField(),
            const SizedBox(height: 20),
            _buildQualitySlider(),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}
