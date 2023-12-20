// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DeviceDropdown extends StatefulWidget {
  final String labelText;
  final List<String> deviceList;
  final Function(String) onSelected;

  const DeviceDropdown({
    required this.labelText,
    required this.deviceList,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  _DeviceDropdownState createState() => _DeviceDropdownState();
}

class _DeviceDropdownState extends State<DeviceDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.deviceList.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        widget.onSelected(newValue!);
      },
      items: widget.deviceList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
