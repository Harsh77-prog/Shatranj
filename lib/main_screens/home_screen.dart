import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shatranj/main_screens/userdetail.dart';

import '../providers/game_provider.dart';
import '../service/assets_manager.dart';
import 'about_screen.dart';
import 'homeScreenWidgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final List<String> _chessFacts;
  Timer? _factTimer;
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

    _factTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) return;
      setState(() {
        _currentFactIndex = (_currentFactIndex + 1) % _chessFacts.length;
      });
    });
  }

  @override
  void dispose() {
    _factTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    final size = MediaQuery.of(context).size;
    final responsiveGap = size.height * 0.04; // smaller on short screens

    return Scaffold(
      backgroundColor:Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            flexibleSpace: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.notes_rounded, color: Colors.white70, size: 26),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => buildSheet(),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 24),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: responsiveGap),
              Material(
                elevation: 6,
                shape: const CircleBorder(),
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent, Color(0xFF00C4FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 28, 36, 41),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(AssetsManager.chessIcon),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsiveGap / 2),
              Column(
                children: [
                  Text(
                    'SHATRANJ',
                    style: GoogleFonts.lato(
                      fontSize: 44, // slightly smaller for safety
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      foreground: Paint()..shader = linearGradient,
                      shadows: const [
                        Shadow(blurRadius: 10.0, color: Colors.black54, offset: Offset(2, 2)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PROVE YOUR GENIUS',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1.5,
                      shadows: const [
                        Shadow(blurRadius: 4.0, color: Colors.black38, offset: Offset(1, 1)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: responsiveGap),
              // No Expanded here; GridView is sized to its content
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                childAspectRatio: 3,
                crossAxisCount: 1,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  GestureDetector(
                    onTap: () {
                      gameProvider.setVsComputer(value: true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserDetailPage()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 30, 30, 30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.cyanAccent,
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                          ),
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1F1F1F), Color(0xFF2C2C2C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Text(
                        'PLAY',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 24,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.cyanAccent, blurRadius: 12, offset: Offset(0, 0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Padding(
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
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}

Shader linearGradient = const LinearGradient(
  colors: <Color>[
    Color(0xFF004AFF),
    Color(0xFF00D7FF),
    Color(0xFFFFFFFF),
  ],
).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0));
