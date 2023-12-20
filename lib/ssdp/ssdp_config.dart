class SsdpConfig {
  static const multicast = _Multicast();

  SsdpConfig._(); // Private constructor to prevent instantiation
}

// default constants that is specific to peerdiscovery in go
// https://github.com/schollz/peerdiscovery
class _Multicast {
  final String address = '239.255.255.250';
  final int port = 9999;

  const _Multicast(); // Constant constructor
}
