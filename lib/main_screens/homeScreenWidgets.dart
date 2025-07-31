import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildGameType({
  required String label,
  required VoidCallback onTap,
  required Color color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent, // To ensure the Container's color is visible
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 33, 33, 33),
              offset: Offset(15, 15),
              blurRadius: 30,
            ),
            BoxShadow(
              color: Color.fromARGB(255, 33, 33, 33),
              offset: Offset(-15, -15),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 33, 33, 33),
                fontSize: 60, // Adjust font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget buildSheet() {
  return ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    child: FractionallySizedBox(
      heightFactor: 0.7,
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Decorative drag handle
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Title
                Text(
                  'RULES',
                  style: GoogleFonts.lato(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.blueAccent.withOpacity(0.8), blurRadius: 10),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white24, thickness: 1.2),

                // Section: Objective
                _buildSectionTitle('OBJECTIVE:'),
                _buildSectionText("CHECKMATE YOUR OPPONENT'S KING."),
                const SizedBox(height: 16),
                Divider(color: Colors.white24, thickness: 1.2),

                // Section: Setup
                _buildSectionTitle('SETUP:'),
                _buildSectionText("8X8 GRID, EACH PLAYER STARTS WITH 16 PIECES."),
                const SizedBox(height: 16),
                Divider(color: Colors.white24, thickness: 1.2),

                // Section: Movement
                _buildSectionTitle('MOVEMENT:'),
                _buildSectionText("EACH TYPE OF PIECE HAS ITS OWN MOVEMENT RULES."),
                const SizedBox(height: 16),
                Divider(color: Colors.white24, thickness: 1.2),

                // Section: Special Moves
                _buildSectionTitle('SPECIAL MOVES:'),
                _buildSectionText("CASTLING, EN PASSANT, AND PROMOTION."),
                const SizedBox(height: 16),
                Divider(color: Colors.white24, thickness: 1.2),

                // Section: Endgame
                _buildSectionTitle('ENDGAME:'),
                _buildSectionText("CHECKMATE, STALEMATE, OR DRAW BY OTHER MEANS."),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// Reusable subheading
Widget _buildSectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

// Reusable description text
Widget _buildSectionText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 16,
        color: Colors.white70,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

