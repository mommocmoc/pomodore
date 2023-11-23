import 'package:flutter/material.dart';
import 'package:Pomodore/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF4EDDB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE7626C),
          brightness: Brightness.light,
          background: const Color(0xFFE7626C),
          primaryContainer: const Color(0xFFF4EDDB),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
