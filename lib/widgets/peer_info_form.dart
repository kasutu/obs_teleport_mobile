// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

class PeerInfoForm extends StatefulWidget {
  const PeerInfoForm({Key? key}) : super(key: key);

  @override
  _PeerInfoFormState createState() => _PeerInfoFormState();
}

class _PeerInfoFormState extends State<PeerInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _portController = TextEditingController();
  double _currentSliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _identifierController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your identifier',
              ),
            ),
            TextFormField(
              controller: _portController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your port',
              ),
              keyboardType: TextInputType.number,
            ),
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Logger.info('Identifier: ${_identifierController.text}');
                  Logger.info('Port: ${_portController.text}');
                  Logger.info('Quality: ${_currentSliderValue.round()}');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
