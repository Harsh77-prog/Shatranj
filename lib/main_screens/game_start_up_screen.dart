import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/game_provider.dart';
import '../widgets/widgets.dart';

class GameStartUpScreen extends StatefulWidget {
  const GameStartUpScreen({
    Key? key,
    required this.isCustomTime,
    required this.gameTime,
  }) : super(key: key);

  final bool isCustomTime;
  final String gameTime;

  @override
  State<GameStartUpScreen> createState() => _GameStartUpScreenState();
}

class _GameStartUpScreenState extends State<GameStartUpScreen> {
  int whiteTimeInMinutes = 0;
  int blackTimeInMinutes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          automaticallyImplyLeading: false, // Remove the default back arrow
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back, // Custom back arrow icon
                    color: Color.fromARGB(255, 232, 232, 232), // Color of the back arrow
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                Spacer(),
                InfoButton(),
              ],
            ),
          ),
        ),

        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('PLAY AS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: const Color.fromARGB(255, 232, 232, 232),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 232, 232, 232),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(25, 25, 25, 1.0),
                              offset: Offset(15, 15),
                              blurRadius: 30,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(60, 60, 60, 1.0),
                              offset: Offset(-15, -15),
                              blurRadius: 30,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 232, 232, 232),
                                  Color.fromARGB(255, 232, 232, 232),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: PlayerColorRadioButton(
                                title: '${PlayerColor.WHITE.name}',
                                value: PlayerColor.WHITE,
                                groupValue: gameProvider.playerColor,
                                onChanged: (value) {
                                  gameProvider.setPlayerColor(player: 0);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Add other widgets here


                      widget.isCustomTime
                          ? BuildCustomTime(
                        time: whiteTimeInMinutes.toString(),
                        onLeftArrowClicked: () {
                          setState(() {
                            whiteTimeInMinutes--;
                          });
                        },
                        onRightArrowClicked: () {
                          setState(() {
                            whiteTimeInMinutes++;
                          });
                        },
                      )
                          : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromARGB(255, 232, 232, 232),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              widget.gameTime,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 232, 232, 232),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 33, 33, 33),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: PlayerColorRadioButton(
                              title: '${PlayerColor.BLACK.name}',
                              value: PlayerColor.BLACK,
                              groupValue: gameProvider.playerColor,
                              onChanged: (value) {
                                gameProvider.setPlayerColor(player: 1);
                              },
                            ),
                          ),
                        ),
                      ),
                      widget.isCustomTime
                          ? BuildCustomTime(
                        time: blackTimeInMinutes.toString(),
                        onLeftArrowClicked: () {
                          setState(() {
                            blackTimeInMinutes--;
                          });
                        },
                        onRightArrowClicked: () {
                          setState(() {
                            blackTimeInMinutes++;
                          });
                        },
                      )
                          : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromARGB(255, 232, 232, 232),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              widget.gameTime,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 232, 232, 232),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  gameProvider.vsComputer
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'OPPONENT',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: const Color.fromARGB(255, 232, 232, 232),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15,),



                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 65,
                              width: MediaQuery.of(context).size.width * 1,
                              child: GameLevelRadioButton(
                                title: '         GRANDEE',
                                value: GameDifficulty.GRANDEE,
                                groupValue: gameProvider.gameDifficulty,
                                onChanged: (value) {
                                  gameProvider.setGameDifficulty(level: 1);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 65,
                              width: MediaQuery.of(context).size.width * 1,
                              child: GameLevelRadioButton(
                                title: '         ARDASHIR',
                                value: GameDifficulty.ARDASHIR,
                                groupValue: gameProvider.gameDifficulty,
                                onChanged: (value) {
                                  gameProvider.setGameDifficulty(level: 2);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 65,
                              width: MediaQuery.of(context).size.width * 1,
                              child: GameLevelRadioButton(
                                title: '            CAÏSSA',
                                value: GameDifficulty.CAISSA,
                                groupValue: gameProvider.gameDifficulty,
                                onChanged: (value) {
                                  gameProvider.setGameDifficulty(level: 3);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  gameProvider.isLoading
                      ? const LinearProgressIndicator()
                      :ElevatedButton(
                    onPressed: () {
                      playGame(gameProvider: gameProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: const Color.fromARGB(255, 232, 232, 232), // Change the color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      textStyle: GoogleFonts.lato(fontSize: 20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'PLAY',
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          color: const Color.fromARGB(255, 33, 33, 33),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ));
  }

  void playGame({required GameProvider gameProvider}) async {

    if (widget.isCustomTime) {
      if (whiteTimeInMinutes <= 0 || blackTimeInMinutes <= 0) {
        showSnackBar(context: context, content: 'Time cannot be 0');
        return;
      }

      gameProvider.setIsLoading(value: true);

      await gameProvider
          .setGameTime(
        newSavedWhitesTime: whiteTimeInMinutes.toString(),
        newSavedBlacksTime: blackTimeInMinutes.toString(),
      )
          .whenComplete(() {
        if (gameProvider.vsComputer) {
          gameProvider.setIsLoading(value: false);
          Navigator.pushNamed(context, Constants.gameScreen);
        } else {
          // search for players
        }
      });
    } else {
      final String incrementalTime = widget.gameTime.split('+')[1];
      final String gameTime = widget.gameTime.split('+')[0];

      if (incrementalTime != '0') {
        gameProvider.setIncrementalValue(value: int.parse(incrementalTime));
      }

      gameProvider.setIsLoading(value: true);

      await gameProvider
          .setGameTime(
        newSavedWhitesTime: gameTime,
        newSavedBlacksTime: gameTime,
      )
          .whenComplete(() {
        if (gameProvider.vsComputer) {
          gameProvider.setIsLoading(value: false);
          Navigator.pushNamed(context, Constants.gameScreen);
        }
      });
    }
  }
}


class InfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline_rounded,
          color: Color.fromARGB(255, 232, 232, 232)),
      onPressed: () {
        _showBottomSheet(context);
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // Occupies 60% of the screen height
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Scaffold(
              backgroundColor: Color.fromARGB(255, 33, 33, 33),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Container(
                    color: Color.fromARGB(255, 33, 33, 33),
                    // Change this to your desired background color
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30,),
                        Text(
                          'OPPONENTS',
                          style: GoogleFonts.lato(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 232, 232, 232),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'GRANDEE' ,
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Color.fromARGB(255, 232, 232, 232), // Change this to your desired color
                          ),
                        ),

                        Text(
                          "A NOBLE FIGURE IN THE REALM OF CHESS, GRANDEE BOASTS AN ELO OF 1000. DESPITE HIS NOBLE MONIKER, HE HUMBLY EMBRACES HIS ROLE. WITH A KEEN STRATEGIC ACUMEN, HE ARTFULLY MANEUVERS HIS PIECES, EXPLOITING OPPONENTS' MISTAKES. ON AND OFF THE BOARD, HE RADIATES A SENSE OF ELEGANCE AND RESPECT, TRULY EMBODYING THE ESSENCE OF A GENTLEMAN OF CHESS.",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Color.fromARGB(255, 232, 232, 232), // Change this to your desired color
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'ARDASHIR ',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Color.fromARGB(255, 232, 232, 232), // Change this to your desired color
                          ),
                        ),

                        Text(
                          "A NAME STEEPED IN ANCIENT MAJESTY, HE'S A PROUD CHESS PLAYER WITH AN ELO RATING OF 2000. BOLD AND UNAPOLOGETIC, HE COMMANDS THE BOARD WITH CONFIDENCE, CHALLENGING OPPONENTS. WITH A RAZOR-SHARP INTELLECT AND AGGRESSIVE TACTICS, HE DOMINATES, CRUSHING FOES WITH PRECISION.",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Color.fromARGB(255, 232, 232, 232), // Change this to your desired color
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'CAÏSSA ',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Color.fromARGB(255, 232, 232, 232), // Change this to your desired color
                          ),
                        ),

                        Text(
                          'THE REVERED GODDESS OF SHATRANJ, WITH AN ELO RATING OF 3000, DISPLAYS UNPARALLELED MASTERY. WITH DIVINE INSIGHT, SHE ORCHESTRATES THE BOARD, HER MOVES TRANSCENDING MORTAL COMPREHENSION. UNFOLDING STRATEGIES WITH GRACE, SHE NAVIGATES WITH EFFORTLESS FINESSE, LEAVING OPPONENTS IN AWE.',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Color.fromARGB(255, 232, 232, 232), // Change this to your desired color
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}