import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shatranj/providers/game_provider.dart';

import 'authentication/landing_screen.dart';
import 'authentication/login_screen.dart';
import 'authentication/sign_up_screen.dart';
import 'constants.dart';
import 'main_screens/game_screen.dart';
import 'main_screens/game_time_screen.dart';
import 'main_screens/home_screen.dart';
import 'main_screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: Constants.loginScreen,
      routes: {
        Constants.homeScreen: (context) => const HomeScreen(),
        Constants.gameScreen: (context) => const GameScreen(),
        Constants.settingScreen: (context) => const SettingsScreen(),
        // Constants.aboutScreen: (context) => const AboutScreen(),
        Constants.gameTimeScreen: (context) => const GameTimeScreen(),
        Constants.loginScreen: (context) => const LoginScreen(),
        Constants.signUpScreen: (context) => const SignUpScreen(),
        Constants.landingScreen: (context) => const LandingScreen(),
      },
    );
  }
}
