import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        appBar:AppBar(
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          automaticallyImplyLeading: false, // Disable automatic back arrow

          leading: IconButton( // Custom back arrow
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
            icon: const Icon(
              Icons.arrow_back, // Back arrow icon
              color: Color.fromARGB(255, 232, 232, 232), // Arrow color
            ),
          ),
          actions: [
            // logout button
            IconButton(

              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 232, 232, 232), // Logout button color
              ), onPressed: () {  },
            ),
          ],
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'SETTINGS',
                style: GoogleFonts.lato(
                  fontSize: 60,
                  color: Color.fromARGB(255, 232, 232, 232),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Align text to center horizontally
              ),
              SizedBox(height: 20), // Add spacing between the texts
              Text(
                'Nothing here yet...',
                style: GoogleFonts.lato(
                  color: Color.fromARGB(255, 232, 232, 232),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Align text to center horizontally
              ),
            ],
          ),
        )

    );
  }
}