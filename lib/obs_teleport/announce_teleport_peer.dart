import 'dart:io';
import 'dart:math';
import 'package:obs_teleport_mobile/global/types.dart';
import 'package:obs_teleport_mobile/ssdp/ssdp_announcer.dart';
import 'package:obs_teleport_mobile/stream/console.dart';

class AnnounceTeleportPeer {
  late Announcer announcer;
  final Random _random = Random();
  String? name;
  int port = 0;
  int quality;

  AnnounceTeleportPeer({this.name, this.port = 0, required this.quality}) {
    _setAnnouncer();
  }

  void _setAnnouncer() {
    assert(quality >= 1 && quality <= 100, 'Quality must be between 1 and 100');

    if (port == 0) {
      port = _randomPort();
    }

    String finalName = (name == null || name!.isEmpty) ? _getHostName() : name!;

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
    return Platform.localHostname;
  }

  int _randomPort() {
    return _random.nextInt(65535) + 1; // Random port between 1 and 65535
  }

  Future<void> startAnnouncer() async {
    while (true) {
      try {
        await announcer.startAnnouncer();
        break; // If startAnnouncer succeeds, break the loop
      } catch (e) {
        Console.error(
            'Error starting SSDP announcer: $e, maybe port is taken, Changing port...');
        port = _randomPort(); // Generate a new port
        _setAnnouncer(); // Set the announcer with the new port
      }
    }
  }

  Future<void> stopAnnouncer() async {
    await announcer.stopAnnouncer();
  }
}
