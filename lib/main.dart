// ignore_for_file: library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/models/settings_model.dart';
import 'package:obs_teleport_mobile/obs_teleport/announce_teleport_peer.dart';
import 'package:obs_teleport_mobile/screens/logger_screen.dart';
import 'package:obs_teleport_mobile/screens/sources_screen.dart';
import 'package:obs_teleport_mobile/screens/settings_screen.dart';
import 'package:obs_teleport_mobile/screens/monitor_screen.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> builtInCameras;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  builtInCameras = await availableCameras();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        hintColor: Colors.blueAccent,
        fontFamily: 'Roboto',
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late AnnounceTeleportPeer announcer;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsModel>(context, listen: false);

    // Initialize the announcer with settings
    announcer = AnnounceTeleportPeer(
      name: settings.announceTeleportPeerName,
      port: settings.announceTeleportPeerPort,
      quality: settings.announceTeleportPeerQuality,
    );

    // Start announcer if isTeleporting is true on init
    if (settings.isTeleporting) {
      announcer.startAnnouncer();
    }

    // Listen for changes in settings
    settings.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    final settings = Provider.of<SettingsModel>(context, listen: false);

    // Update the announcer with new settings if necessary
    bool shouldReinitialize = false;

    if (announcer.name != settings.announceTeleportPeerName) {
      shouldReinitialize = true;
    }
    if (announcer.port != settings.announceTeleportPeerPort) {
      shouldReinitialize = true;
    }
    if (announcer.quality != settings.announceTeleportPeerQuality) {
      shouldReinitialize = true;
    }

    if (shouldReinitialize) {
      // Stop the current announcer
      if (announcer.isAnnouncing) {
        announcer.stopAnnouncer();
      }

      // Reinitialize the announcer with updated settings
      announcer = AnnounceTeleportPeer(
        name: settings.announceTeleportPeerName,
        port: settings.announceTeleportPeerPort,
        quality: settings.announceTeleportPeerQuality,
      );

      // Start the announcer if isTeleporting is true
      if (settings.isTeleporting) {
        announcer.startAnnouncer();
      }
    } else {
      // Only start/stop announcer if there's an actual change in teleporting state
      if (settings.isTeleporting && !announcer.isAnnouncing) {
        announcer.startAnnouncer();
      } else if (!settings.isTeleporting && announcer.isAnnouncing) {
        announcer.stopAnnouncer();
      }
    }
  }

  @override
  void dispose() {
    // Stop the announcer when the widget is disposed
    if (announcer.isAnnouncing) {
      announcer.stopAnnouncer();
    }

    // Remove listener
    final settings = Provider.of<SettingsModel>(context, listen: false);
    settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OBS Teleport'),
        actions: [
          Switch(
            value: settings.isTeleporting,
            onChanged: (newValue) {
              settings.isTeleporting = newValue;
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          MonitorScreen(),
          SettingsScreen(),
          SourcesScreen(),
          LoggerScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      unselectedItemColor: Theme.of(context).colorScheme.tertiary,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_input_svideo),
          label: 'Sources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.terminal),
          label: 'Logger',
        ),
      ],
    );
  }
}
