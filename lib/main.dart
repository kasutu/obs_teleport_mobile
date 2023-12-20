// File: lib/main.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/obs_teleport/announce_teleport_peer.dart';
import 'package:obs_teleport_mobile/screens/sources_screen.dart';
import 'package:obs_teleport_mobile/screens/settings_screen.dart';
import 'package:obs_teleport_mobile/screens/monitor_screen.dart';

late List<CameraDescription> builtInCameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  builtInCameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildThemeData(),
      home: const MyHomePage(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      hintColor: Colors.blueAccent,
      fontFamily: 'Roboto',
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
      ),
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
  final PageController _pageController = PageController();
  late AnnounceTeleportPeer announcer;
  bool isBroadcasting = false; // Move the isBroadcasting variable here

  void _initAnnouncer() {
    announcer = AnnounceTeleportPeer(name: 'OBS teleport mobile', quality: 90);
  }

  @override
  void initState() {
    super.initState();
    _initAnnouncer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OBS Teleport',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        actions: [_buildHeaderSwitch(context)],
      ),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PageView _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() => _selectedIndex = index);
      },
      children: const <Widget>[
        MonitorScreen(),
        SourcesScreen(),
        SettingsScreen()
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.monitor),
          label: 'Monitor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.input),
          label: 'Sources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Widget _buildHeaderSwitch(BuildContext context) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.play_arrow); // Icon for broadcasting state
        }
        return const Icon(Icons.stop); // Icon for stopped state
      },
    );

    return Switch(
      thumbIcon: thumbIcon,
      value: isBroadcasting,
      onChanged: (bool value) {
        setState(() {
          isBroadcasting = value;
          if (isBroadcasting) {
            _startAnnouncer();
          } else {
            _stopAnnouncer();
          }
        });
      },
    );
  }

  Future<void> _startAnnouncer() async {
    await announcer.startAnnouncer();
  }

  Future<void> _stopAnnouncer() async {
    await announcer.stopAnnouncer();
  }
}
