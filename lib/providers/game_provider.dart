import 'dart:async';

import 'package:bishop/bishop.dart'as bishop;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:stockfish/stockfish.dart';

import '../constants.dart';
import '../helper/uci_commands.dart';

class GameProvider extends ChangeNotifier {
  late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);
  bool _aiThinking = false;
  bool _flipBoard = false;
  bool _vsComputer = false;
  bool _vsPlayer = false;
  bool _isLoading = false;
  bool _playWhitesTimer = true;
  bool _playBlacksTimer = true;
  int _gameLevel = 1;
  int _incrementalValue = 0;
  int _player = Squares.white;
  Timer? _whitesTimer;
  Timer? _blacksTimer;
  int _whitesScore = 0;
  int _blacksSCore = 0;
  PlayerColor _playerColor = PlayerColor.WHITE;
  GameDifficulty _gameDifficulty = GameDifficulty.GRANDEE;


  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // saved time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

  bool get playWhitesTimer => _playWhitesTimer;

  bool get playBlacksTimer => _playBlacksTimer;

  int get whitesScore => _whitesScore;

  int get blacksScore => _blacksSCore;

  Timer? get whitesTimer => _whitesTimer;

  Timer? get blacksTimer => _blacksTimer;

  bishop.Game get game => _game;

  SquaresState get state => _state;

  bool get aiThinking => _aiThinking;

  bool get flipBoard => _flipBoard;

  int get gameLevel => _gameLevel;

  GameDifficulty get gameDifficulty => _gameDifficulty;

  int get incrementalValue => _incrementalValue;

  int get player => _player;

  PlayerColor get playerColor => _playerColor;

  Duration get whitesTime => _whitesTime;

  Duration get blacksTime => _blacksTime;

  Duration get savedWhitesTime => _savedWhitesTime;

  Duration get savedBlacksTime => _savedBlacksTime;

  // get method
  bool get vsComputer => _vsComputer;

  bool get vsPlayer => _vsPlayer;

  bool get isLoading => _isLoading;


  // set play whitesTimer
  Future<void> setPlayWhitesTimer({required bool value}) async {
    _playWhitesTimer = value;
    notifyListeners();
  }

  // set play blacksTimer
  Future<void> setPlayBlactsTimer({required bool value}) async {
    _playBlacksTimer = value;
    notifyListeners();
  }

  // get position fen
  getPositionFen() {
    return game.fen;
  }

  // reset game
  void resetGame({required bool newGame}) {
    if (newGame) {
      // check if the player was white in the previous game
      // change the player
      if (_player == Squares.white) {
        _player = Squares.black;
      } else {
        _player = Squares.white;
      }
      notifyListeners();
    }
    // reset game
    _game = bishop.Game(variant: bishop.Variant.standard());
    _state = game.squaresState(_player);
  }

  // make squre move
  bool makeSquaresMove(Move move) {
    bool result = game.makeSquaresMove(move);
    notifyListeners();
    return result;
  }

  // make squre move
  bool makeStringMove(String bestMove) {
    bool result = game.makeMoveString(bestMove);
    notifyListeners();
    return result;
  }

  // set sqaures state
  Future<void> setSquaresState() async {
    _state = game.squaresState(player);
    notifyListeners();
  }

  // make random move
  void makeRandomMove() {
    _game.makeRandomMove();
    notifyListeners();
  }

  void flipTheBoard() {
    _flipBoard = !_flipBoard;
    notifyListeners();
  }

  void setAiThinking(bool value) {
    _aiThinking = value;
    notifyListeners();
  }

  // set incremental value
  void setIncrementalValue({required int value}) {
    _incrementalValue = value;
    notifyListeners();
  }

  // set vs computer
  void setVsComputer({required bool value}) {
    _vsComputer = value;
    notifyListeners();
  }

  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  // set game time
  Future<void> setGameTime({
    required String newSavedWhitesTime,
    required String newSavedBlacksTime,
  }) async {
    // save the times
    _savedWhitesTime = Duration(minutes: int.parse(newSavedWhitesTime));
    _savedBlacksTime = Duration(minutes: int.parse(newSavedBlacksTime));
    notifyListeners();
    // set times
    setWhitesTime(_savedWhitesTime);
    setBlacksTime(_savedBlacksTime);
  }

  void setWhitesTime(Duration time) {
    _whitesTime = time;
    notifyListeners();
  }

  void setBlacksTime(Duration time) {
    _blacksTime = time;
    notifyListeners();
  }

  // set playerColor
  void setPlayerColor({required int player}) {
    _player = player;
    _playerColor =
    player == Squares.white ? PlayerColor.WHITE : PlayerColor.BLACK;
    notifyListeners();
  }

  // set difficulty
  void setGameDifficulty({required int level}) {
    _gameLevel = level;
    _gameDifficulty = level == 1
        ? GameDifficulty.GRANDEE
        : level == 2
        ? GameDifficulty.ARDASHIR
        : GameDifficulty.CAISSA;
    notifyListeners();
  }

  // pause whites timer
  void pauseWhitesTimer() {
    if (_whitesTimer != null) {
      _whitesTime += Duration(seconds: _incrementalValue);
      _whitesTimer!.cancel();
      notifyListeners();
    }
  }

  // pause blacks timer
  void pauseBlacksTimer() {
    if (_blacksTimer != null) {
      _blacksTime += Duration(seconds: _incrementalValue);
      _blacksTimer!.cancel();
      notifyListeners();
    }
  }

  // start blacks timer
  void startBlacksTimer({
    required BuildContext context,
    Stockfish? stockfish,
    required Function onNewGame,
  }) {
    _blacksTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _blacksTime = _blacksTime - const Duration(seconds: 1);
      notifyListeners();

      if (_blacksTime <= Duration.zero) {
        // blacks timeout - black has lost the game
        _blacksTimer!.cancel();
        notifyListeners();

        // show game over dialog
        if (context.mounted) {
          gameOverDialog(
            context: context,
            stockfish: stockfish,
            timeOut: true,
            whiteWon: true,
            onNewGame: onNewGame,
          );
        }
      }
    });
  }

  // start blacks timer
  void startWhitesTimer({
    required BuildContext context,
    Stockfish? stockfish,
    required Function onNewGame,
  }) {
    _whitesTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _whitesTime = _whitesTime - const Duration(seconds: 1);
      notifyListeners();

      if (_whitesTime <= Duration.zero) {
        // whites timeout - white has lost the game
        _whitesTimer!.cancel();
        notifyListeners();

        // show game over dialog
        if (context.mounted) {
          gameOverDialog(
            context: context,
            stockfish: stockfish,
            timeOut: true,
            whiteWon: false,
            onNewGame: onNewGame,
          );
        }
      }
    });
  }

  void gameOverListerner({
    required BuildContext context,
    Stockfish? stockfish,
    required Function onNewGame,
  }) {
    if (game.gameOver) {
      // pause the timers
      pauseWhitesTimer();
      pauseBlacksTimer();

      // cancel the gameStreamsubscription if its not null
      // if (gameStreamSubScreiption != null) {
      //   gameStreamSubScreiption!.cancel();
      // }

      // show game over dialog
      if (context.mounted) {
        gameOverDialog(
          context: context,
          stockfish: stockfish,
          timeOut: false,
          whiteWon: false,
          onNewGame: onNewGame,
        );
      }
    }
  }

  // game over dialog
  void gameOverDialog({
    required BuildContext context,
    Stockfish? stockfish,
    required bool timeOut,
    required bool whiteWon,
    required Function onNewGame,
  }) {
    // stop stockfish engine
    if (stockfish != null) {
      stockfish.stdin = UCICommands.stop;
    }
    String resultsToShow = '';
    int whitesScoresToShow = 0;
    int blacksSCoresToShow = 0;

    // check if its a timeOut
    if (timeOut) {
      // check who has won and increment the results accordingly
      if (whiteWon) {
        resultsToShow = 'WHITE WON ON TIME';
        whitesScoresToShow = _whitesScore + 1;
      } else {
        resultsToShow = 'BLACK WON ON TIME';
        blacksSCoresToShow = _blacksSCore + 1;
      }
    } else {
      // its not a timeOut
      resultsToShow = game.result!.readable;

      if (game.drawn) {
        // game is a draw
        String whitesResults = game.result!
            .scoreString
            .split('-')
            .first;
        String blacksResults = game.result!
            .scoreString
            .split('-')
            .last;
        whitesScoresToShow = _whitesScore += int.parse(whitesResults);
        blacksSCoresToShow = _blacksSCore += int.parse(blacksResults);
      } else if (game.winner == 0) {
        // meaning white is the winner
        String whitesResults = game.result!
            .scoreString
            .split('-')
            .first;
        whitesScoresToShow = _whitesScore += int.parse(whitesResults);
      } else if (game.winner == 1) {
        // meaning black is the winner
        String blacksResults = game.result!
            .scoreString
            .split('-')
            .last;
        blacksSCoresToShow = _blacksSCore += int.parse(blacksResults);
      } else if (game.stalemate) {
        whitesScoresToShow = whitesScore;
        blacksSCoresToShow = blacksScore;
      }
    }
    final gameProvider = context.read<GameProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            title: Text(
              'GAME OVER\n $whitesScoresToShow - $blacksSCoresToShow',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              resultsToShow, style: GoogleFonts.lato(),
              textAlign: TextAlign.center,
            ),
            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // navigate to home screen
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Constants.gameTimeScreen,
                        (route) => false,
                  );
                },
                child:
                Text(
                  'TRY AGAIN',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 36, 41)),
                ),
              ),

            ],
          ),
    );
  }
}