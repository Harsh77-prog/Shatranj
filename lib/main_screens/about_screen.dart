import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message =
        'Dear Shatranj Player,\n\n'
        'Thank you for downloading Shatranj and joining us on this journey. Shatranj, which means "chess" is not just a game, it\'s a tradition that has transcended generations, cultures, and borders.\n\n'
        'Derived from the ancient Indian game of Chaturanga, Shatranj has a rich history dating back over a millennium. It has evolved over the centuries, captivating minds with its strategies and depth of play.\n\n'
        'In the true spirit of Shatranj, you\'re on your own with no hints provided. This approach enhances critical thinking, decision-making skills, and creativity. This game is designed for those who consider themselves the best, as it challenges your mind without any assistance. This is how a strategy game should be really played.\n\n'
        'Thank you for being a part of the Shatranj community. Keep playing, keep strategizing, and keep challenging yourself!\n\n'
        'Best Regards,\n'
        'Shatranj';

    String capitalizedMessage = capitalizeEachLetter(message);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back when the back arrow is tapped
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Change the color of the arrow as desired
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NOTE FROM\nTHE DEVELOPER.',
              textAlign: TextAlign.center, // Align text to the center
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 20), // Add space between the text widgets
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 232, 232, 232),
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Color.fromRGBO(25, 25, 25, 1.0),
                  //     offset: Offset(15, 15),
                  //     blurRadius: 30,
                  //   ),
                  //   BoxShadow(
                  //     color: Color.fromRGBO(60, 60, 60, 1.0),
                  //     offset: Offset(-15, -15),
                  //     blurRadius: 30,
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    capitalizedMessage,
                    style: GoogleFonts.lato(
                      color: Color.fromARGB(255, 33, 33, 33),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeEachLetter(String text) {
    return text.toUpperCase();
  }
}