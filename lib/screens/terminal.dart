// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/global/types.dart';
import 'package:obs_teleport_mobile/obs_teleport/announce_teleport_peer.dart';
import 'package:obs_teleport_mobile/ssdp/ssdp_announcer.dart';
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
  late AnnounceTeleportPeer announcer;

  @override
  void initState() {
    super.initState();
    _initAnnouncer();
    _initLogStream();
  }

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
            _buildHeader(),
            _buildConsole(),
          ],
        ),
      ),
      floatingActionButton: _buildStopButton(),
    );
  }

  void _initAnnouncer() {
    announcer = AnnounceTeleportPeer(name: 'OBS teleport mobile', quality: 90);
  }

  void _initLogStream() {
    _logStream = Console.logStream;
    Console.info('Started terminal');
  }

  void _disposeResources() {
    _textEditingController.dispose();
    Console.close();
  }

  Widget _buildHeader() {
    return SizedBox(
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
          _buildHeaderButtons(),
        ],
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: _startAnnouncer,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _clearConsole,
        ),
      ],
    );
  }

  Widget _buildConsole() {
    return Expanded(
      child: StreamText(
        textStream: _logStream,
      ),
    );
  }

  Widget _buildStopButton() {
    return FloatingActionButton(
      onPressed: _stopAnnouncer,
      tooltip: 'Stop Announcer',
      child: const Icon(Icons.stop_circle),
    );
  }

  Future<void> _startAnnouncer() async {
    await announcer.startAnnouncer();
  }

  Future<void> _stopAnnouncer() async {
    await announcer.stopAnnouncer();
  }

  void _clearConsole() {
    setState(() {
      Console.clear();
    });
  }
}
