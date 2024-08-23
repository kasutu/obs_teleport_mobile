import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'native_image_converter_bindings_generated.dart';

/// Convert YUV420 to RGBA using the native function.
///
/// This function is designed to be called on a separate isolate to avoid
/// blocking the main isolate and causing dropped frames in Flutter applications.
Future<void> convertYuv420ToRgbaAsync(
  Pointer<Uint8> yuvData,
  Pointer<Uint8> rgbaData,
  int width,
  int height,
) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final _Yuv420ToRgbaRequest request =
      _Yuv420ToRgbaRequest(yuvData, rgbaData, width, height);
  final Completer<void> completer = Completer<void>();
  _conversionRequests[request.id] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

const String _libName = 'native_image_converter';

/// The dynamic library in which the symbols for [NativeImageConverterBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NativeImageConverterBindings _bindings =
    NativeImageConverterBindings(_dylib);

/// A request to perform YUV420 to RGBA conversion.
class _Yuv420ToRgbaRequest {
  static int _nextId = 0;
  final int id;
  final Pointer<Uint8> yuvData;
  final Pointer<Uint8> rgbaData;
  final int width;
  final int height;

  _Yuv420ToRgbaRequest(
    this.yuvData,
    this.rgbaData,
    this.width,
    this.height,
  ) : id = _nextId++;
}

/// Mapping from request `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<void>> _conversionRequests = <int, Completer<void>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can send it requests.
        completer.complete(data);
        return;
      }
      if (data is int) {
        // The helper isolate sent us a response indicating that the conversion is complete.
        final Completer<void> completer = _conversionRequests.remove(data)!;
        completer.complete();
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _Yuv420ToRgbaRequest) {
          _bindings.yuv420_to_rgba(
            data.yuvData,
            data.rgbaData,
            data.width,
            data.height,
          );
          sendPort.send(
              data.id); // Send the request ID back to indicate completion.
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
