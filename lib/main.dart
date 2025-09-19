import 'package:flutter/material.dart';
import 'package:music_train/screens/splash_screen.dart';
import 'package:music_train/screens/home_screen.dart';
import 'package:music_train/screens/training_screen.dart';
import 'package:music_train/screens/stats_screen.dart';
import 'package:music_train/services/music_theory_service.dart';
import 'package:music_train/services/timer_service.dart';
import 'package:music_train/services/reward_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MusicTrainApp());
}

class MusicTrainApp extends StatelessWidget {
  const MusicTrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicTheoryService()),
        ChangeNotifierProvider(create: (_) => TimerService()),
        ChangeNotifierProvider(create: (_) => RewardService()),
      ],
      child: MaterialApp(
        title: 'Music Train',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/training': (context) => const TrainingScreen(),
          '/stats': (context) => const StatsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}