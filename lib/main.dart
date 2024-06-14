import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shatranj/providers/game_provider.dart';

import 'authentication/landing_screen.dart';
import 'constants.dart';
import 'main_screens/game_screen.dart';
import 'main_screens/game_time_screen.dart';
import 'main_screens/home_screen.dart';
import 'main_screens/settings_screen.dart';

void main() async {

  // await SentryFlutter.init(
  //       (options) {
  //     options.dsn = 'https://d919bc50a27a2220c2f1e043043917f6@o4507265518010368.ingest.us.sentry.io/4507265522597888';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 0.01;
  //     // The sampling rate for profiling is relative to tracesSampleRate
  //     // Setting to 1.0 will profile 100% of sampled transactions:
  //     options.profilesSampleRate = 1.0;
  //   },
  //   // appRunner: () => runApp(MyApp()),
  // );

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
      initialRoute: Constants.landingScreen,
      routes: {
        Constants.homeScreen: (context) => const HomeScreen(),
        Constants.gameScreen: (context) => const GameScreen(),
        Constants.settingScreen: (context) => const SettingsScreen(),
        // Constants.aboutScreen: (context) => const AboutScreen(),
        Constants.gameTimeScreen: (context) => const GameTimeScreen(),
        // Constants.loginScreen: (context) => const LoginScreen(),
        // Constants.signUpScreen: (context) => const SignUpScreen(),
        Constants.landingScreen: (context) => const LandingScreen(),

      },
    );
  }
}
