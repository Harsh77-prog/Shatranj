import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../service/assets_manager.dart';
import 'about_screen.dart';
import 'game_time_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final List<String> _chessFacts;
  late final Timer _factTimer;
  int _currentFactIndex = 0;

  @override
  void initState() {
    super.initState();
    _chessFacts = [
      'THE LONGEST CHESS GAME THEORETICALLY POSSIBLE IS 5,949 MOVES.',
      'THE WORD "CHECKMATE" IN CHESS COMES FROM THE PERSIAN PHRASE "SHAH MAT," WHICH MEANS "THE KING IS DEAD."',
      'THE SECOND BOOK EVER PRINTED IN THE ENGLISH LANGUAGE WAS ABOUT CHESS.',
      'THE NUMBER OF POSSIBLE WAYS OF PLAYING THE FIRST FOUR MOVES FOR BOTH SIDES IN A CHESS GAME IS 318,979,564,000.',
      'THE LONGEST OFFICIAL CHESS GAME TOOK OVER 20 HOURS AND ENDED IN A DRAW.',
      'CHESS WAS FIRST PLAYED IN INDIA OVER 1,500 YEARS AGO.',
      'THE MODERN CHESS BOARD AS WE KNOW IT TODAY FIRST APPEARED IN EUROPE IN THE 15TH CENTURY.',
      'THE SHORTEST POSSIBLE CHESS GAME TO ACHIEVE CHECKMATE IS KNOWN AS THE "FOOL\'S MATE" AND CAN BE DONE IN JUST TWO MOVES.',
      'CHESS IS CONSIDERED TO BE ONE OF THE MOST COMPLEX GAMES, WITH MORE POSSIBLE POSITIONS THAN THERE ARE ATOMS IN THE OBSERVABLE UNIVERSE.',
      'MANY FAMOUS HISTORICAL FIGURES, INCLUDING NAPOLEON BONAPARTE AND BENJAMIN FRANKLIN, WERE AVID CHESS PLAYERS.',
      'THE FIRST OFFICIAL WORLD CHESS CHAMPIONSHIP WAS HELD IN 1886.',
      'COMPUTERS HAVE BEEN PLAYING CHESS SINCE THE MID-20TH CENTURY, WITH IBM\'S DEEP BLUE FAMOUSLY DEFEATING WORLD CHAMPION GARRY KASPAROV IN 1997.',
      'THE LONGEST-RUNNING CHESS TOURNAMENT IS THE HASTINGS INTERNATIONAL CHESS CONGRESS, WHICH BEGAN IN 1895.',
      'IN CHESS NOTATION, THE FIRST RECORDED GAME DATES BACK TO 1475.',
      'THE "EN PASSANT" RULE, UNIQUE TO CHESS, ALLOWS A PAWN TO CAPTURE AN OPPONENT\'S PAWN IN A SPECIAL WAY.',
    ];
    _factTimer = Timer.periodic(Duration(seconds: 8), (timer) {
      setState(() {
        _currentFactIndex = (_currentFactIndex + 1) % _chessFacts.length;
      });
    });
  }

  @override
  void dispose() {
    _factTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notes_rounded,
                color: Color.fromARGB(255, 232, 232, 232),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => buildSheet(),
                );
              },
            ),
            Spacer(),
            IconButton(
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Color.fromARGB(255, 232, 232, 232),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Material(
              shape: CircleBorder(),
              child: Container(
                width: 120,
                height:120,
                decoration: const BoxDecoration(
                  // shape: BoxShape.circle,
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Color.fromARGB(255, 248, 248, 245).withOpacity(0.9),
                  //     Color.fromARGB(255, 248, 248, 245).withOpacity(0.6),
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromARGB(255, 28, 36, 41),
                  backgroundImage: AssetImage(AssetsManager.chessIcon),
                ),
              ),
            ),
            SizedBox(width: 20),
            Text(
              'SHATRANJ',
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 232, 232, 232),
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'PROVE YOUR GENIUS',
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 232, 232, 232),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 130),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 20,
                childAspectRatio: 3,
                crossAxisCount: 1,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildGameType(
                    label: 'PLAY',

                    onTap: () {
                      gameProvider.setVsComputer(value: true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameTimeScreen(),
                        ),
                      );
                    },
                    color: Color.fromARGB(255, 232, 232, 232),
                  ),
                ],
              ),
            ),
            // Add some spacing between the buttons

            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _chessFacts[_currentFactIndex],
                style: GoogleFonts.lato(
                  color: Color.fromARGB(255, 232, 232, 232),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        heightFactor: 0.7, // Set the height to 30% of the screen
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'RULES',
                        style: GoogleFonts.lato(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 232, 232, 232),
                        ),
                        textAlign: TextAlign.center, // Center align text
                      ),
                    ),
                    Text(
                      'OBJECTIVE:',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ), // Center align text
                    ),
                    Text(
                      'CHECKMATE YOUR OPPONENT\'S KING.',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ),
                      textAlign: TextAlign.center, // Center align text
                    ),
                    Text(
                      'SETUP:',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ), // Center align text
                    ),
                    Text(
                      '8X8 GRID, EACH PLAYER STARTS WITH 16 PIECES.',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ),
                      textAlign: TextAlign.center, // Center align text
                    ),
                    Text(
                      'MOVEMENT:',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ), // Center align text
                    ),
                    Text(
                      'EACH TYPE OF PIECE HAS ITS OWN MOVEMENT RULES.',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ),
                      textAlign: TextAlign.center, // Center align text
                    ),
                    Text(
                      'SPECIAL MOVES:',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ), // Center align text
                    ),
                    Text(
                      'CASTLING, EN PASSANT, AND PROMOTION.',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ),
                      textAlign: TextAlign.center,// Center align text
                    ),
                    Text(
                      'ENDGAME:',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ), // Center align text
                    ),
                    Text(
                      'CHECKMATE, STALEMATE, OR DRAW BY OTHER MEANS.',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color.fromARGB(255, 232, 232, 232), // Set your desired text color
                      ),
                      textAlign: TextAlign.center, // Center align text
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



}