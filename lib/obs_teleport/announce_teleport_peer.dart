import 'dart:io';
import 'dart:math';
import 'package:obs_teleport_mobile/global/types.dart';
import 'package:obs_teleport_mobile/ssdp/ssdp_announcer.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

class AnnounceTeleportPeer {
  late Announcer announcer;
  final Random _random = Random();
  String? name;
  int port = 0;
  double quality;
  bool isAnnouncing = false; // New property to track the state of the announcer

  AnnounceTeleportPeer({this.name, this.port = 0, required this.quality}) {
    Logger.info(
        'AnnounceTeleportPeer created with name: $name, port: $port, quality: $quality');
    _setAnnouncer();
  }

  void _setAnnouncer() {
    assert(quality >= 1 && quality <= 100, 'Quality must be between 1 and 100');

    if (port == 0) {
      port = _randomPort();
    }

    String finalName = (name == null || name!.isEmpty) ? _getHostName() : name!;
    Logger.info(
        'Setting announcer with name: $finalName, port: $port, quality: $quality');

    announcer = Announcer(
      payload: ObsTeleportPeer(
        name: finalName,
        port: port,
        audioAndVideo: quality >= 50,
        version: '0.7.0',
      ),
    );
  }

  String _getHostName() {
    String hostName = Platform.localHostname;
    Logger.info('Host name: $hostName');
    return hostName;
  }

  int _randomPort() {
    int randomPort =
        _random.nextInt(65535) + 1; // Random port between 1 and 65535
    Logger.info('Generated random port: $randomPort');
    return randomPort;
  }

  Future<void> startAnnouncer() async {
    if (isAnnouncing) {
      Logger.info('Announcer is already running on port: $port');
      return;
    }

    while (true) {
      try {
        Logger.info('Starting announcer on port: $port');
        await announcer.startAnnouncer();
        isAnnouncing = true; // Set the flag to true when announcer starts
        Logger.info('Announcer started successfully on port: $port');
        break; // If startAnnouncer succeeds, break the loop
      } catch (e) {
        Logger.error(
            'Error starting SSDP announcer: $e, maybe port is taken, Changing port...');
        port = _randomPort(); // Generate a new port
        _setAnnouncer(); // Set the announcer with the new port
      }
    }
  }

  Future<void> stopAnnouncer() async {
    if (!isAnnouncing) {
      Logger.info('Announcer is not running, nothing to stop.');
      return;
    }

    Logger.info('Stopping announcer on port: $port');
    await announcer.stopAnnouncer();
    isAnnouncing = false; // Set the flag to false when announcer stops
    Logger.info('Announcer stopped successfully');
  }
}
