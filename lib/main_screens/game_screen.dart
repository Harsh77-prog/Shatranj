import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:squares/squares.dart';
import 'package:stockfish/stockfish.dart';

import '../constants.dart';
import '../helper/helper_methods.dart';
import '../helper/uci_commands.dart';
import '../providers/game_provider.dart';
import '../service/assets_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Stockfish stockfish;
  final Random random = Random();

  @override
  void initState() {
    stockfish = Stockfish();
    final gameProvider = context.read<GameProvider>();
    gameProvider.resetGame(newGame: false);

    if (mounted) {
      letOtherPlayerPlayFirst();
    }
    super.initState();
  }

  @override
  void dispose() {
    stockfish.dispose();
    super.dispose();
  }

  void letOtherPlayerPlayFirst() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final gameProvider = context.read<GameProvider>();

      if (gameProvider.vsComputer) {
        if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
          gameProvider.setAiThinking(true);

          await waitUntilReady();

          // Introduce random delay before making the move
          await Future.delayed(Duration(milliseconds: random.nextInt(500) + 500));

          stockfish.stdin = '${UCICommands.position} ${gameProvider.getPositionFen()}';
          stockfish.stdin = '${UCICommands.goMoveTime} ${gameProvider.gameLevel * 1000}';

          stockfish.stdout.listen((event) {
            if (event.contains(UCICommands.bestMove)) {
              final bestMove = event.split(' ')[1];
              gameProvider.makeStringMove(bestMove);
              gameProvider.setAiThinking(false);
              gameProvider.setSquaresState().whenComplete(() {
                if (gameProvider.player == Squares.white) {
                  if (gameProvider.playWhitesTimer) {
                    gameProvider.pauseBlacksTimer();
                    startTimer(isWhiteTimer: true, onNewGame: () {});
                    gameProvider.setPlayWhitesTimer(value: false);
                  }
                } else {
                  if (gameProvider.playBlacksTimer) {
                    gameProvider.pauseWhitesTimer();
                    startTimer(isWhiteTimer: false, onNewGame: () {});
                    gameProvider.setPlayBlactsTimer(value: false);
                  }
                }
              });
            }
          });
        }
      } else {
        // Code for other player scenarios
      }
    });
  }


  void _onMove(Move move) async {
    print('move: ${move.toString()}');
    print('String move: ${move.algebraic()}');
    final gameProvider = context.read<GameProvider>();
    bool result = gameProvider.makeSquaresMove(move);
    if (result) {
      gameProvider.setSquaresState().whenComplete(() async {
        if (gameProvider.player == Squares.white) {
          if (gameProvider.vsComputer) {
            gameProvider.pauseWhitesTimer();
            startTimer(isWhiteTimer: false, onNewGame: () {});
            gameProvider.setPlayWhitesTimer(value: true);
          }
        } else {
          if (gameProvider.vsComputer) {
            gameProvider.pauseBlacksTimer();
            startTimer(isWhiteTimer: true, onNewGame: () {});
            gameProvider.setPlayBlactsTimer(value: true);
          }
        }
      });
    }



    if (gameProvider.vsComputer) {
      if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
        gameProvider.setAiThinking(true);

        await waitUntilReady();

        // Introduce random delay before making the move
        await Future.delayed(Duration(milliseconds: random.nextInt(500) + 500));

        stockfish.stdin = '${UCICommands.position} ${gameProvider.getPositionFen()}';
        stockfish.stdin = '${UCICommands.goMoveTime} ${gameProvider.gameLevel * 1000}';

        stockfish.stdout.listen((event) {
          if (event.contains(UCICommands.bestMove)) {
            final bestMove = event.split(' ')[1];
            gameProvider.makeStringMove(bestMove);
            gameProvider.setAiThinking(false);
            gameProvider.setSquaresState().whenComplete(() {
              if (gameProvider.player == Squares.white) {
                if (gameProvider.playWhitesTimer) {
                  gameProvider.pauseBlacksTimer();
                  startTimer(isWhiteTimer: true, onNewGame: () {});
                  gameProvider.setPlayWhitesTimer(value: false);
                }
              } else {
                if (gameProvider.playBlacksTimer) {
                  gameProvider.pauseWhitesTimer();
                  startTimer(isWhiteTimer: false, onNewGame: () {});
                  gameProvider.setPlayBlactsTimer(value: false);
                }
              }
            });
          }
        });
      }
    }

    await Future.delayed(const Duration(seconds: 3));
    checkGameOverListener();
  }

  Future<void> waitUntilReady() async {
    while (stockfish.state.value != StockfishState.ready) {
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void checkGameOverListener() {
    final gameProvider = context.read<GameProvider>();

    gameProvider.gameOverListerner(
      context: context,
      stockfish: stockfish,
      onNewGame: () {
        // start new game
      },
    );
  }

  void startTimer({
    required bool isWhiteTimer,
    required Function onNewGame,
  }) {
    final gameProvider = context.read<GameProvider>();
    if (isWhiteTimer) {
      gameProvider.startWhitesTimer(
        context: context,
        stockfish: stockfish,
        onNewGame: onNewGame,
      );
    } else {
      gameProvider.startBlacksTimer(
        context: context,
        stockfish: stockfish,
        onNewGame: onNewGame,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    return WillPopScope(
      onWillPop: () async {
        bool? leave = await _showExitConfirmDialog(context);
        return leave ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 232, 232, 232),
            ),
            onPressed: () {
              _showExitConfirmDialog(context);
            },
          ),
          backgroundColor: Color.fromARGB(255, 33, 33, 33),

          actions: [
            // IconButton(
            //   onPressed: () {
            //     gameProvider.resetGame(newGame: false);
            //   },
            //   icon: const Icon(Icons.start, color: Color.fromARGB(255, 76, 50, 35)),
            // ),
            IconButton(
              onPressed: () {
                gameProvider.flipTheBoard();
              },
              icon: const Icon(Icons.rotate_left, color: Color.fromARGB(255, 232, 232, 232)),
            ),
          ],
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            String whitesTimer = getTimerToDisplay(
              gameProvider: gameProvider,
              isUser: true,
            );
            String blacksTimer = getTimerToDisplay(
              gameProvider: gameProvider,
              isUser: false,
            );
            return Center(
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        elevation: 10,
                        // shadowColor: Color.fromARGB(255, 248, 248, 245).withOpacity(1),
                        shape: CircleBorder(),
                        child: Container(
                          width: 40,
                          height: 40,
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
                          fontSize: 40, // Adjust font size as needed
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),


                    ],
                  ),



                  const SizedBox(height: 30,),
                  // opponents data
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Add rounded corners
                      color: const Color.fromARGB(255, 232, 232, 232), // Set the background color of the container
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(25, 25, 25, 1.0),
                          offset: Offset(-15, -15),
                          blurRadius: 30,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(60, 60, 60, 1.0),
                          offset: Offset(15, 15),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: showOpponentsData(
                      gameProvider: gameProvider,
                      timeToShow: blacksTimer,
                    ),
                  ),
                  const SizedBox(height: 30,),



                  gameProvider.vsComputer
                      ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: BoardController(
                      state: gameProvider.flipBoard
                          ? gameProvider.state.board.flipped()
                          : gameProvider.state.board,
                      playState: gameProvider.state.state,
                      pieceSet: PieceSet.merida(),
                      theme: BoardTheme.blueGrey,
                      moves: gameProvider.state.moves,
                      onMove: _onMove,
                      onPremove: _onMove,
                      markerTheme: MarkerTheme(
                        empty: MarkerTheme.dot,
                        piece: MarkerTheme.corners(),
                      ),
                      promotionBehaviour: PromotionBehaviour.autoPremove,
                    ),
                  )
                      : buildChessBoard(
                    gameProvider: gameProvider,
                  ),

                  const SizedBox(height: 30,),

                  // our data
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Add rounded corners
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 232, 232, 232),
                          Color.fromARGB(255, 232, 232, 232),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(25, 25, 25, 1.0),
                          offset: Offset(7, 7),
                          blurRadius: 15,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(60, 60, 60, 1.0),
                          offset: Offset(-7, -7),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 33, 33, 33), // Set the border color
                              width: 3.0, // Set the border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(AssetsManager.userIcon),
                          ),
                        ),


                        title: Text(
                          'ROOK',
                          style: GoogleFonts.lato(
                            color: Color.fromARGB(255, 33, 33, 33),
                            fontSize: 20,
                          ),
                        ),
                        trailing: Text(
                          whitesTimer,
                          style: GoogleFonts.lato(fontSize: 20, color: Color.fromARGB(255, 33, 33, 33)),
                        ),
                      ),
                    ),
                  ),





                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildChessBoard({
    required GameProvider gameProvider,

  }) {
    bool isOurTurn = gameProvider.player ==Squares.white;

    print('CHESS UID: ${gameProvider.player}');

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: BoardController(
        state: gameProvider.flipBoard
            ? gameProvider.state.board.flipped()
            : gameProvider.state.board,
        playState: isOurTurn ? PlayState.ourTurn : PlayState.theirTurn,
        pieceSet: PieceSet.merida(),
        theme: BoardTheme.blueGrey,
        moves: gameProvider.state.moves,
        onMove: _onMove,
        onPremove: _onMove,
        markerTheme: MarkerTheme(
          empty: MarkerTheme.dot,
          piece: MarkerTheme.corners(),
        ),
        promotionBehaviour: PromotionBehaviour.autoPremove,
      ),
    );
  }

  getState({required GameProvider gameProvider}) {
    if (gameProvider.flipBoard) {
      return gameProvider.state.board.flipped();
    } else {
      gameProvider.state.board;
    }
  }

  Widget showOpponentsData({
    required GameProvider gameProvider,
    required String timeToShow,
  }) {
    String opponentImage;

    // Select the appropriate image based on the game difficulty level
    switch (gameProvider.gameDifficulty) {
      case GameDifficulty.GRANDEE:
        opponentImage = AssetsManager.grandeeIcon;
        break;
      case GameDifficulty.ARDASHIR:
        opponentImage = AssetsManager.ardashirIcon;
        break;
      case GameDifficulty.CAISSA:
        opponentImage = AssetsManager.caissaIcon;
        break;
      default:
        opponentImage = AssetsManager.stockfishIcon;
    }

    gameProvider.vsComputer; {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading:Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromARGB(255, 33, 33, 33), // Set the border color
                width: 3.0, // Set the border width
              ),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(opponentImage),
            ),
          ),

          title: Text(
            '${gameProvider.gameDifficulty.name}',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: Color.fromARGB(255, 33, 33, 33),
            ),
          ),
          trailing: Text(
            timeToShow,
            style: GoogleFonts.lato(
              fontSize:20,
              color: Color.fromARGB(255, 33, 33, 33),
            ),
          ),
        ),
      );

    }
  }


  Future<bool?> _showExitConfirmDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(
          'LEAVE GAME?',
          textAlign: TextAlign.center,style: GoogleFonts.lato(),
        ),
        content: Text(
          'TOO HARD?',
          textAlign: TextAlign.center, style: GoogleFonts.lato(),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child:  Text('CANCEL'),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Constants.homeScreen,
                        (route) => false, // Replace HomeScreen with the actual name of your screen/widget
                  );
                },

                child:  Text('YES'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}