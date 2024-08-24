// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PeerInfoForm extends StatefulWidget {
  final TextEditingController identifierController;
  final TextEditingController portController;
  final TextEditingController qualityController;
  final ValueChanged<String>? onIdentifierChanged;
  final ValueChanged<int>? onPortChanged;
  final ValueChanged<double>? onQualityChanged;

  const PeerInfoForm({
    super.key,
    required this.identifierController,
    required this.portController,
    required this.qualityController,
    this.onIdentifierChanged,
    this.onPortChanged,
    this.onQualityChanged,
  });

  @override
  _PeerInfoFormState createState() => _PeerInfoFormState();
}

class _PeerInfoFormState extends State<PeerInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late FocusNode _identifierFocusNode;
  late FocusNode _portFocusNode;

  @override
  void initState() {
    super.initState();
    _identifierFocusNode = FocusNode();
    _portFocusNode = FocusNode();

    _identifierFocusNode.addListener(_onIdentifierFocusChange);
    _portFocusNode.addListener(_onPortFocusChange);
  }

  @override
  void dispose() {
    _identifierFocusNode.removeListener(_onIdentifierFocusChange);
    _portFocusNode.removeListener(_onPortFocusChange);

    _identifierFocusNode.dispose();
    _portFocusNode.dispose();
    super.dispose();
  }

  void _onIdentifierFocusChange() {
    if (!_identifierFocusNode.hasFocus) {
      widget.onIdentifierChanged?.call(widget.identifierController.text);
    }
  }

  void _onPortFocusChange() {
    if (!_portFocusNode.hasFocus) {
      final portValue = int.tryParse(widget.portController.text);
      if (portValue != null) {
        widget.onPortChanged?.call(portValue);
      }
    }
  }

  void _onQualityChangeEnd() {
    final qualityValue = double.tryParse(widget.qualityController.text);
    if (qualityValue != null) {
      widget.onQualityChanged?.call(qualityValue);
    }
  }

  Widget _buildIdentifierField() {
    return TextFormField(
      controller: widget.identifierController,
      focusNode: _identifierFocusNode,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Identifier',
        helperText: 'Enter identifier (optional), default is Hostname',
      ),
      keyboardType: TextInputType.name,
    );
  }

  Widget _buildPortField() {
    return TextFormField(
      controller: widget.portController,
      focusNode: _portFocusNode,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Port',
        helperText: 'Enter port (optional), default is auto',
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
      ), // Adjusted for integer input
    );
  }

  Widget _buildQualityField() {
    // Cache the parsed value to avoid multiple parsing
    final qualityValue = double.tryParse(widget.qualityController.text) ?? 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quality'),
        Slider(
          value: qualityValue,
          min: 1,
          max: 100,
          divisions: 99,
          label: '${qualityValue.round()}%',
          onChanged: (double value) {
            widget.qualityController.text = value.toString();
            setState(() {}); // Update UI after changing the slider value
          },
          onChangeEnd: (value) {
            _onQualityChangeEnd();
          },
        ),
        Text('Current Quality: ${qualityValue.round()}%'),
      ],
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
          children: [
            _buildIdentifierField(),
            const SizedBox(height: 20),
            _buildPortField(),
            const SizedBox(height: 20),
            _buildQualityField(),
          ],
        ),
      ),
    );
  }
}
