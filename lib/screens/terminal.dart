// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/mdns/announcer.dart';
import 'package:obs_teleport_mobile/mdns/discoverer.dart';
import 'package:obs_teleport_mobile/stream/console.dart';
import '../widgets/stream_text.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({Key? key}) : super(key: key);

  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  late final Stream<String> _logStream;

  bool _isDiscoverable = false;

  bool _checkConnection() {
    return false;
  }

  void _clearConsole() {
    setState(() {
      Console.clear();
    });
  }

  void _startDiscoverer() {
    final discoverer = Discoverer();

    discoverer.startDiscoverer();
  }

  Future<void> _enableDiscovery() async {
    final announcer = Announcer(
      name: 'foo',
      port: 12345,
      audioAndVideo: true,
      version: '0.7.0',
    );

    await announcer.startAnnouncer();
    Console.log('Started announcer');
  }

  void handleDiscoveryState() {
    setState(() {
      // Toggle _isDiscoverable
      _isDiscoverable = !_isDiscoverable;
    });
  }

  @override
  void initState() {
    super.initState();
    Console.info('Started terminal');

    _isDiscoverable = _checkConnection();

    _logStream = Console.logStream;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    Console.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: kToolbarHeight, // Use the same height as AppBar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'OBS Teleport Mobile',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isDiscoverable
                              ? Icons.play_arrow
                              : Icons.play_disabled,
                          color: _isDiscoverable ? Colors.green : Colors.grey,
                        ),
                        onPressed: _enableDiscovery,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: _clearConsole,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamText(
                textStream: _logStream,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startDiscoverer,
        tooltip: 'Start Scan',
        child: const Icon(Icons.search),
      ),
    );
  }
}
