// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/obs_teleport/announce_teleport_peer.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

class TeleportInterfaceScreen extends StatefulWidget {
  const TeleportInterfaceScreen({Key? key}) : super(key: key);

  @override
  _TeleportInterfaceScreenState createState() =>
      _TeleportInterfaceScreenState();
}

class _TeleportInterfaceScreenState extends State<TeleportInterfaceScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late AnnounceTeleportPeer announcer;
  bool isBroadcasting = false; // Move the isBroadcasting variable here

  @override
  void initState() {
    super.initState();
    _initAnnouncer();
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
            _buildHeader(context),
          ],
        ),
      ),
    );
  }

  void _initAnnouncer() {
    announcer = AnnounceTeleportPeer(name: 'OBS teleport mobile', quality: 90);
  }

  void _disposeResources() {
    _textEditingController.dispose();
    Logger.close();
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'OBS Teleport',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          _buildHeaderButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeaderButtons(BuildContext context) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.play_arrow); // Icon for broadcasting state
        }
        return const Icon(Icons.stop); // Icon for stopped state
      },
    );

    return Switch(
      thumbIcon: thumbIcon,
      value: isBroadcasting,
      onChanged: (bool value) {
        setState(() {
          isBroadcasting = value;
          if (isBroadcasting) {
            _startAnnouncer();
          } else {
            _stopAnnouncer();
          }
        });
      },
    );
  }

  Future<void> _startAnnouncer() async {
    await announcer.startAnnouncer();
  }

  Future<void> _stopAnnouncer() async {
    await announcer.stopAnnouncer();
  }
}
