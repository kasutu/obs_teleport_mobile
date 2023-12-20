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
