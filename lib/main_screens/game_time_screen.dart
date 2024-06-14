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
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
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
                  Navigator.pop(context); // Navigate back to the previous screen
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
            Text(
              'GAME TYPE',
              style: GoogleFonts.lato(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 232, 232, 232),
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
                    double childAspectRatio = constraints.maxWidth > 600 ? 3 : 4;

                    return SingleChildScrollView(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        childAspectRatio: childAspectRatio,
                        crossAxisCount: crossAxisCount,
                        children: [
                          buildGameType(
                            label: 'BULLET',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => buildSheet(label: 'Bullet'),
                              );
                            },
                            gameTime: '',
                          ),
                          buildGameType(
                            label: 'BLITZ',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => buildSheet(label: 'Blitz'),
                              );
                            },
                            gameTime: '',
                          ),
                          buildGameType(
                            label: 'RAPID',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => buildSheet(label: 'Rapid'),
                              );
                            },
                            gameTime: '',
                          ),
                          buildGameType(
                            label: 'CLASSICAL',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => buildSheet(label: 'Classical'),
                              );
                            },
                            gameTime: '',
                          ),
                          buildGameType(
                            label: 'CUSTOM',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameStartUpScreen(
                                    isCustomTime: true,
                                    gameTime: '',
                                  ),
                                ),
                              );
                            },
                            gameTime: '',
                          ),
                        ],
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
      heightFactor: 0.6, // 60% of the screen height
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'GAME TYPE',
                    style: GoogleFonts.lato(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 232, 232, 232),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      'MASTER ALL THE FORMATS OF CHESS GAMES SUCH AS BULLET, BLITZ, RAPID, CLASSICAL, AND CUSTOM GAMES. '
                          'SELECT A GAME TYPE TO START PLAYING. EACH TYPE OFFERS DIFFERENT TIME CONTROLS SUITED TO VARIOUS PLAY STYLES. ENJOY YOUR GAME!',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 232, 232, 232),
                      ),
                    ),
                  ),
                ),
              ],
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
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'TIME',
                  style: GoogleFonts.lato(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 232, 232, 232),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 16 / 9,
                  ),
                  itemCount: filteredGameTimes.length,
                  itemBuilder: (context, index) {
                    final String customLabel = customNames[index];
                    final String gameTime = filteredGameTimes[index];

                    return buildGameType(
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
        return ['Default Name 1', 'Default Name 2', 'Default Name 3', 'Default Name 4'];
    }
  }

  List<String> getFilteredGameTimes(String label) {
    final Map<String, List<String>> gameTimes = {
      'Bullet': ['1+0', '2+1', '3+0'],
      'Blitz': ['3+2', '5+0', '5+5'],
      'Rapid': ['10+0', '15+10', '25+0'],
      'Classical': ['30+0', '45+45', '60+0'],
    };
    return gameTimes[label] ?? ['Default Time 1', 'Default Time 2', 'Default Time 3', 'Default Time 4'];
  }

  Widget buildGameType({
    required String label,
    required VoidCallback onTap,
    required String gameTime,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 232, 232), // Set the background color of the container
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 33, 33, 33),
              offset: Offset(7, 7),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Color.fromARGB(255, 33, 33, 33),
              offset: Offset(-7, -7),
              blurRadius: 15,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 232, 232, 232),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lato(
                    color: const Color.fromARGB(255, 33, 33, 33), // Text color
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}