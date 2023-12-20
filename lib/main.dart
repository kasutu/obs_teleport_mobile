import 'package:flutter/material.dart';
import 'package:obs_teleport_mobile/screens/teleport_interface_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark, // Set the brightness to dark
        primarySwatch: Colors.blueGrey, // Set the primary color to blue-grey
        hintColor: Colors.blueAccent, // Set the accent color to blue
        fontFamily: 'Roboto', // Set the global font family to Roboto
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                Colors.white, // Set the text color of text buttons to white
          ),
        ),
      ),
      home: const TeleportInterfaceScreen(),
    );
  }
}
