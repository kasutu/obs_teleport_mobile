import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:obs_teleport_mobile/global/types.dart';
import 'package:obs_teleport_mobile/ssdp/ssdp_config.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

// custom implementation of SSD Protocol
class Announcer {
  final ObsTeleportPeer payload;
  RawDatagramSocket? _udpSocket;
  InternetAddress? _multicastAddress;
  Timer? _timer;

  Announcer({required this.payload});

  Future<void> startAnnouncer() async {
    try {
      Logger.log('Starting SSDP announcer...');
      _udpSocket = await _createAndConfigureSocket();
      Logger.log('UDP socket created and configured');
      _joinMulticastGroup();
      Logger.log('Joined multicast group');
      var payloadBytes = _getPayloadBytes();
      _startTimer(payloadBytes);
      Logger.log('Timer started');
    } catch (e) {
      Logger.log('Error starting SSDP announcer: $e');
      rethrow;
    }
  }

  Future<void> stopAnnouncer() async {
    try {
      Logger.log('Stopping SSDP announcer...');
      _timer?.cancel();
      _udpSocket?.close();
      Logger.log('SSDP announcer stopped');
    } catch (e) {
      Logger.log('Error stopping SSDP announcer: $e');
      rethrow;
    }
  }

  // Extracted methods for better readability and separation of concerns
  Future<RawDatagramSocket> _createAndConfigureSocket() async {
    try {
      var socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, payload.port);
      socket.multicastHops = 1;
      socket.broadcastEnabled = true;
      return socket;
    } catch (e) {
      Logger.log('Error creating and configuring UDP socket: $e');
      rethrow;
    }
  }

  void _joinMulticastGroup() {
    _multicastAddress = InternetAddress(SsdpConfig.multicast.address);
    _udpSocket!.joinMulticast(_multicastAddress!);
  }

  Uint8List _getPayloadBytes() {
    var payloadJson = json.encode(payload.toJson());
    return utf8.encode(payloadJson);
  }

  void _startTimer(Uint8List payloadBytes) {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        _udpSocket!.send(
          payloadBytes,
          _multicastAddress!,
          SsdpConfig.multicast.port,
        );

        Logger.log(
            'Sent SSDP announcement with payload: ${utf8.decode(payloadBytes)}');
      });
    } catch (e) {
      Logger.log('Error starting timer: $e');
      rethrow;
    }
  }
}
