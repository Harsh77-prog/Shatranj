
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shatranj/providers/game_provider.dart';
import 'main_screens/landing_screen.dart';
import 'constants.dart';

import 'main_screens/game_screen.dart';
import 'main_screens/game_time_screen.dart';
import 'main_screens/home_screen.dart';

import 'main_screens/userdetail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => GameProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shatranj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),

      //home: const HomeScreen(),
      initialRoute: Constants.homeScreen,
      routes: {
        Constants.homeScreen: (context) => const HomeScreen(),
        Constants.gameScreen: (context) => const GameScreen(),
        Constants.userdetails: (context) => const UserDetailPage(),

        // Constants.aboutScreen: (context) => const AboutScreen(),
        Constants.gameTimeScreen: (context) => const GameTimeScreen(),
        Constants.landingScreen: (context) => const LandingScreen(),
      },
    );
  }
}
