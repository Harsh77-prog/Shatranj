import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = '''
Dear Shatranj Player,

Thank you for downloading Shatranj and joining us on this journey. Shatranj, which means "chess" is not just a game, it's a tradition that has transcended generations, cultures, and borders.

Derived from the ancient Indian game of Chaturanga, Shatranj has a rich history dating back over a millennium. It has evolved over the centuries, captivating minds with its strategies and depth of play.

In the true spirit of Shatranj, you're on your own with no hints provided. This approach enhances critical thinking, decision-making skills, and creativity. This game is designed for those who consider themselves the best, as it challenges your mind without any assistance. This is how a strategy game should be really played.

Thank you for being a part of the Shatranj community. Keep playing, keep strategizing, and keep challenging yourself!

Best Regards,  
Shatranj
''';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blueAccent, Colors.cyanAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'NOTE FROM\nTHE DEVELOPER.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message,
                    style: GoogleFonts.robotoMono(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      letterSpacing: 0.6,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
