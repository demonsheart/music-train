import 'package:flutter/material.dart';
import 'package:music_train/screens/splash_screen.dart';
import 'package:music_train/screens/home_screen_simple.dart';
import 'package:music_train/screens/training_screen_basic.dart';

void main() {
  runApp(const MusicTrainApp());
}

class MusicTrainApp extends StatelessWidget {
  const MusicTrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Train',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreenSimple(),
        '/training': (context) => const TrainingScreenBasic(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}