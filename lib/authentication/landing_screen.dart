import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../service/assets_manager.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    navigateAfterDelay();
  }

  void navigateAfterDelay() async {
    // Wait for 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // Navigate to the home screen
    navigateToHome();
  }

  void navigateToHome() {
    Navigator.pushReplacementNamed(context, Constants.homeScreen);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 10,
              // shadowColor: Color.fromARGB(255, 248, 248, 245).withOpacity(1),
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 232, 232, 232),
                      Color.fromARGB(255, 232, 232, 232),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(AssetsManager.chessIcon),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'SHATRANJ',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 232, 232, 232),
                fontSize: 60, // Adjust font size as needed
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),


          ],
        ),
      ),
    );
  }

  void navigate({required bool isSignedIn}) {
    if (isSignedIn) {
      Navigator.pushReplacementNamed(context, Constants.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, Constants.loginScreen);
    }
  }
}

