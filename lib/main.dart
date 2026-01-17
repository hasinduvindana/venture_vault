import 'package:flutter/material.dart';
import 'loading_screen.dart'; // Imports your animation logic

void main() {
  // Ensures Flutter bindings are initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  runApp(VentureVaultApp());
}

class VentureVaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VentureVault',
      debugShowCheckedModeBanner: false,
      
      // Defining a dark modern theme to match your glassy UI
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Or any custom font you add to pubspec.yaml
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // The app starts with the Loading Screen (which lasts 6 seconds)
      home: LoadingScreen(),
    );
  }
}