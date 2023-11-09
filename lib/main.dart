import 'package:flutter/material.dart';
import 'package:timer/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer',
      theme: ThemeData(useMaterial3: false, brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}
