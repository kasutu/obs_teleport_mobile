import 'package:flutter_test/flutter_test.dart';
import 'package:obs_teleport_mobile/global/types.dart';
import 'package:obs_teleport_mobile/ssdp/ssdp_announcer.dart';

void main() {
  group('Announcer', () {
    late Announcer announcer;

    setUp(() {
      announcer = Announcer(
          payload: ObsTeleportPeer(
        name: 'OBS Teleport Mobile Test',
        port: 1234,
        audioAndVideo: true,
        version: '1.0.0',
      ));
    });

    test('starts and stops without errors', () async {
      await announcer.startAnnouncer();
      await announcer.stopAnnouncer();
    });
  });
}
