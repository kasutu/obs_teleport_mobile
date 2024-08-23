import 'dart:async';
import 'dart:typed_data';

import 'package:obs_teleport_mobile/utils/logger.dart';

class Pool {
  final StreamController<ByteBuffer> _bufferController;

  Pool(int maxBuffers)
      : _bufferController = StreamController<ByteBuffer>.broadcast() {
    for (int i = 0; i < maxBuffers; i++) {
      _bufferController.add(Uint8List(0).buffer);
    }
  }

  Future<ByteBuffer> getBuffer() async {
    try {
      return await _bufferController.stream.first;
    } catch (e) {
      return Uint8List(0).buffer;
    }
  }

  void putBuffer(ByteBuffer buffer) {
    buffer.asUint8List().fillRange(0, buffer.lengthInBytes, 0);
    _bufferController.add(buffer);
  }
}

void main() {
  var bufferPool = Pool(10);

  bufferPool.getBuffer().then((buffer) {
    Logger.info('Got buffer: $buffer');
    bufferPool.putBuffer(buffer);
  });
}
