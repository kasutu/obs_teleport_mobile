import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:obs_teleport_mobile/ssdp/ssdp_config.dart';
import 'package:obs_teleport_mobile/utils/logger.dart';

class Discoverer {
  RawDatagramSocket? _udpSocket;
  InternetAddress? _multicastAddress;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get peers => _controller.stream;

  Future<void> startDiscoverer() async {
    Logger.log('Starting SSDP discoverer...');
    _udpSocket = await _createAndConfigureSocket();
    Logger.log('UDP socket created and configured');
    _joinMulticastGroup();
    Logger.log('Joined multicast group');
    _startListening();
    Logger.log('Discoverer started');
  }

  // Extracted methods for better readability and separation of concerns
  Future<RawDatagramSocket> _createAndConfigureSocket() async {
    var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.multicastHops = 1;
    socket.broadcastEnabled = true;
    return socket;
  }

  void _joinMulticastGroup() {
    _multicastAddress = InternetAddress(SsdpConfig.multicast.address);
    _udpSocket!.joinMulticast(_multicastAddress!);
  }

  void _startListening() {
    _udpSocket!.listen((RawSocketEvent e) {
      final datagram = _udpSocket!.receive();
      if (datagram == null) return;

      final String message = utf8.decode(datagram.data);
      final Map<String, dynamic> peer = json.decode(message);
      _controller.add(peer);
    });
  }

  Future<void> stopDiscoverer() async {
    Logger.log('Stopping SSDP discoverer...');
    _udpSocket?.close();
    await _controller.close();
    Logger.log('SSDP discoverer stopped');
  }
}
