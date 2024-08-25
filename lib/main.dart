import 'package:flutter/material.dart';
import 'package:google_map_app/ui/google_map_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Maps Integration',
      debugShowCheckedModeBanner: false,
      home: GoogleMapScreen(),
    );
  }
}

