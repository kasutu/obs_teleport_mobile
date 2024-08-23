class ObsTeleportPeer {
  final String name;
  final int port;
  final bool audioAndVideo;
  final String version;

  ObsTeleportPeer({
    required this.name,
    required this.port,
    required this.audioAndVideo,
    required this.version,
  });

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Port': port,
        'AudioAndVideo': audioAndVideo,
        'Version': version,
      };
}

class AnnouncePayload {
  final String name;
  final int port;
  final bool audioAndVideo;
  final String version;
  final String? address;

  AnnouncePayload({
    required this.name,
    required this.port,
    required this.audioAndVideo,
    required this.version,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Port': port,
        'AudioAndVideo': audioAndVideo,
        'Version': version,
        if (address != null) 'Address': address,
      };
}

class Header {
  final List<int> type;
  final int timestamp;
  final int size;

  Header({
    required this.type,
    required this.timestamp,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'Type': type,
        'Timestamp': timestamp,
        'Size': size,
      };
}

class ImageHeader {
  final List<double> colorMatrix;
  final List<double> colorRangeMin;
  final List<double> colorRangeMax;

  ImageHeader({
    required this.colorMatrix,
    required this.colorRangeMin,
    required this.colorRangeMax,
  });

  Map<String, dynamic> toJson() => {
        'ColorMatrix': colorMatrix,
        'ColorRangeMin': colorRangeMin,
        'ColorRangeMax': colorRangeMax,
      };
}

class WaveHeader {
  final int format;
  final int sampleRate;
  final int speakers;
  final int frames;

  WaveHeader({
    required this.format,
    required this.sampleRate,
    required this.speakers,
    required this.frames,
  });

  Map<String, dynamic> toJson() => {
        'Format': format,
        'SampleRate': sampleRate,
        'Speakers': speakers,
        'Frames': frames,
      };
}
