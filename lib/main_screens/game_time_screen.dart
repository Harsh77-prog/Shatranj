import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import 'game_start_up_screen.dart';

class GameTimeScreen extends StatefulWidget {
  const GameTimeScreen({Key? key}) : super(key: key);

  @override
  _GameTimeScreenState createState() => _GameTimeScreenState();
}

class _GameTimeScreenState extends State<GameTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    print('VS VALUE: ${gameProvider.vsComputer}');
    return Scaffold(
      backgroundColor:Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.black,
        automaticallyImplyLeading: false,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 232, 232, 232),
                ),
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: Color.fromARGB(255, 232, 232, 232),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => buildInfoSheet(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.cyan, Colors.cyanAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'GAME TYPE',
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // Gets masked by shader
                  letterSpacing: 2,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 4,
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.cyanAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine the number of columns and aspect ratio based on the screen size
                    int crossAxisCount = constraints.maxWidth > 600 ? 1 : 1;
                    double childAspectRatio =
                        constraints.maxWidth > 600 ? 3 : 4;

                    return SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black, Color(0xff323232)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          childAspectRatio: childAspectRatio,
                          crossAxisCount: crossAxisCount,
                          children: [
                            buildGradientGameType(
                              context: context,
                              label: 'BULLET',
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    buildSheet(label: 'Bullet'),
                              ),
                            ),
                            buildGradientGameType(
                              context: context,
                              label: 'BLITZ',
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    buildSheet(label: 'Blitz'),
                              ),
                            ),
                            buildGradientGameType(
                              context: context,
                              label: 'RAPID',
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    buildSheet(label: 'Rapid'),
                              ),
                            ),
                            buildGradientGameType(
                              context: context,
                              label: 'CLASSICAL',
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    buildSheet(label: 'Classical'),
                              ),
                            ),
                            buildGradientGameType(
                              context: context,
                              label: 'CUSTOM',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameStartUpScreen(
                                    isCustomTime: true,
                                    gameTime: '',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSheet() {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.grey.shade900.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Glowing Header
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.cyan, Colors.cyanAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'GAME TYPE',
                        style: GoogleFonts.orbitron(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Moving glow bar under title
                  Center(
                    child: Container(
                      height: 4,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.cyanAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'Master all formats of chess including Bullet, Blitz, Rapid, Classical, and Custom Games.\n\n'
                        '⚡ Bullet: Ultra-fast games for adrenaline lovers.\n'
                        '🔥 Blitz: Fast and furious tactical battles.\n'
                        '⏱️ Rapid: Balanced games with deeper strategy.\n'
                        '🎯 Classical: Slow-paced for deep thinkers.\n'
                        '🎛️ Custom: Set your own pace and rules.\n\n'
                        'Choose your style. Let the game begin!',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.grey[300],
                          height: 1.5,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSheet({required String label}) {
    final List<String> customNames = getCustomNames(label);
    final List<String> filteredGameTimes = getFilteredGameTimes(label);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff000000), Color(0xff222222)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Glowing Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.cyan, Colors.cyanAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'TIME',
                      style: GoogleFonts.orbitron(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.white70,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Grid of Game Time Options
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 14,
                      childAspectRatio: 16 / 9,
                    ),
                    itemCount: filteredGameTimes.length,
                    itemBuilder: (context, index) {
                      final String customLabel = customNames[index];
                      final String gameTime = filteredGameTimes[index];

                      return buildGameTypeCard(
                        context: context,
                        label: customLabel,
                        gameTime: gameTime,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStartUpScreen(
                                isCustomTime: label == 'CUSTOM',
                                gameTime: gameTime,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> getCustomNames(String label) {
    switch (label) {
      case 'Bullet':
        return ['1+0', '2+1', '3+0'];
      case 'Blitz':
        return ['3+2', '5+0', '5+5'];
      case 'Rapid':
        return ['10+0', '15+10', '25+0'];
      case 'Classical':
        return ['30+0', '45+45', '60+0'];
      default:
        return [
          'Default Name 1',
          'Default Name 2',
          'Default Name 3',
          'Default Name 4'
        ];
    }
  }

  List<String> getFilteredGameTimes(String label) {
    final Map<String, List<String>> gameTimes = {
      'Bullet': ['1+0', '2+1', '3+0'],
      'Blitz': ['3+2', '5+0', '5+5'],
      'Rapid': ['10+0', '15+10', '25+0'],
      'Classical': ['30+0', '45+45', '60+0'],
    };
    return gameTimes[label] ??
        [
          'Default Time 1',
          'Default Time 2',
          'Default Time 3',
          'Default Time 4'
        ];
  }

  Widget buildGameTypeCard({
    required BuildContext context,
    required String label,
    required String gameTime,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            width: 2,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            '$label\n$gameTime',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.4,
              shadows: const [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black26,
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildGradientGameType({
  required BuildContext context,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan, Colors.cyanAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Colors.white.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.white,
                offset: Offset(1, 1),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
