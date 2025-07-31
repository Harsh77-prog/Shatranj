import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _userName = 'Player';     // <-- default fallback
  String? _userAvatarPath;

  @override
  void initState() {
    _loadUserProfile();
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


  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('userName')?.trim();
      final avatar = prefs.getString('userAvatar');

      if (!mounted) return;
      setState(() {
        _userName = (name != null && name.isNotEmpty) ? name : 'Player';
        _userAvatarPath = (avatar != null && avatar.isNotEmpty) ? avatar : null;
      });
    } catch (_) {
      // keep defaults if anything fails
    }
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 10,
                // shadowColor: Color.fromARGB(255, 248, 248, 245).withOpacity(1),
                shape: CircleBorder(),
                child: Container(
                  width: 20,
                  height: 20,
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
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(AssetsManager.chessIcon),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text(
                'SHATRANJ',
                style: GoogleFonts.lato(
                  color: Colors.cyanAccent,
                  fontSize: 20, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),


            ],
          ),

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
            IconButton(
              onPressed: () {
                gameProvider.flipTheBoard();
              },
              icon: const Icon(Icons.crop_rotate_outlined, color: Color.fromARGB(255, 232, 232, 232)),
            ),
          ],
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            bool isOpponentsTurn = gameProvider.state.state == PlayState.theirTurn;
            bool isUsersTurn = gameProvider.state.state == PlayState.ourTurn;
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00FFE1),
                            Color(0xFF3A3A3A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isOpponentsTurn
                              ? Colors.blueAccent.withOpacity(0.7) // 🔵 Highlight
                              : const Color.fromARGB(255, 0, 0, 0),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00FFE1), // Cyan accent
                            Color(0xFF3A3A3A), // Dark grey
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isUsersTurn
                              ? Colors.cyanAccent.withOpacity(0.3)  // Highlight if it's user's turn
                              : const Color(0xFF000000),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // User Avatar and Name
                              // inside the user container Row (left side: avatar + name)
                              Row(
                                children: [
                                  // size = 44 because radius 22 * 2
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5), // keep your border
                                    ),
                                    clipBehavior: Clip.antiAlias,  // ensures circular clipping
                                    child: Container(
                                               // background behind transparent PNGs
                                      child: Image.asset(
                                        _userAvatarPath ?? AssetsManager.userIcon,
                                        fit: BoxFit.contain,        // 👈 shows entire image without cropping
                                        alignment: Alignment.center,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),
                                  Text(
                                    _userName, // <-- dynamic username from prefs
                                    style: GoogleFonts.orbitron(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),


                              // Timer
                              Text(
                                whitesTimer,
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
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
    String opponentName;

    // Select the appropriate image based on the game difficulty level
    switch (gameProvider.gameDifficulty) {
      case GameDifficulty.GRANDEE:
        opponentImage = AssetsManager.grandeeIcon;
        opponentName = 'Grandee'; // 👈 Add name
        break;
      case GameDifficulty.ARDASHIR:
        opponentImage = AssetsManager.ardashirIcon;
        opponentName = 'Ardashir'; // 👈 Add name
        break;
      case GameDifficulty.CAISSA:
        opponentImage = AssetsManager.caissaIcon;
        opponentName = 'Caïssa'; // 👈 Add name
        break;
      default:
        opponentImage = AssetsManager.stockfishIcon;
        opponentName = 'Stockfish'; // 👈 Add name
    }
    gameProvider.vsComputer; {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 33, 33, 33),
                width: 3.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ClipOval(
              child: Container(
                color: Colors.black,
                child: Image.asset(
                  opponentImage,
                  fit: BoxFit.contain,              // ✅ no zoom/crop
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),

          title: Align(
            alignment: Alignment.centerLeft,        // ← left-align the text
            child: Text(
              opponentName,
              // textAlign: TextAlign.start,        // (optional) also fine
              style: GoogleFonts.orbitron(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                height: 1.3,
              ),
              overflow: TextOverflow.ellipsis,      // avoid overflow
              maxLines: 1,
            ),
          ),


          trailing: Text(
            timeToShow,
            style: GoogleFonts.lato(
              fontSize:20,
              color: Colors.white,
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