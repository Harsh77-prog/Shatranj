import 'dart:async';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:stockfish/stockfish.dart';

import '../constants.dart';
import '../helper/uci_commands.dart';

class Clock {
  Duration remaining;
  final int incrementSeconds;
  Timer? _ticker;
  DateTime? _start;
  final VoidCallback onTimeout;
  final VoidCallback? onTick;

  Duration _lastReportedRemaining = Duration.zero;

  Clock({
    required this.remaining,
    required this.incrementSeconds,
    required this.onTimeout,
    this.onTick,
  });

  bool get isRunning => _start != null;

  void start() {
    if (isRunning) return;

    _start = DateTime.now();
    _lastReportedRemaining = remaining;

    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      final elapsed = DateTime.now().difference(_start!);
      final currentRemaining = remaining - elapsed;

      if (currentRemaining <= Duration.zero) {
        stop();
        remaining = Duration.zero;
        onTimeout();
      } else {
        // Notify only if full second passed
        final diff = (_lastReportedRemaining.inSeconds - currentRemaining.inSeconds).abs();
        if (diff >= 1) {
          _lastReportedRemaining = currentRemaining;
          onTick?.call(); // let GameProvider/UI update
        }
      }
    });
  }

  void stop({bool applyInc = false}) {
    if (!isRunning) return;

    final elapsed = DateTime.now().difference(_start!);
    remaining = remaining - elapsed;
    _start = null;
    _ticker?.cancel();
    _ticker = null;

    // Apply increment safely *after* calculating time
    if (applyInc && incrementSeconds > 0) {
      remaining += Duration(seconds: incrementSeconds);
    }

    if (remaining.isNegative) remaining = Duration.zero;
  }

  String display() {
    final effective = isRunning
        ? (remaining - DateTime.now().difference(_start!))
        : remaining;
    final dur = effective.isNegative ? Duration.zero : effective;
    final minutes = dur.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = (dur.inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Duration currentRemaining() {
    final effective = isRunning
        ? (remaining - DateTime.now().difference(_start!))
        : remaining;
    return effective.isNegative ? Duration.zero : effective;
  }

  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    _start = null;
  }
}


class GameProvider extends ChangeNotifier {
  late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);

  // core flags
  bool _aiThinking = false;
  bool _flipBoard = false;
  bool _vsComputer = false;
  bool _vsPlayer = false;
  bool _isLoading = false;

  int _gameLevel = 1;
  int _incrementalValue = 0; // kept for backward compatibility or external UI usage
  int _player = Squares.white;

  int _whitesScore = 0;
  int _blacksSCore = 0;
  PlayerColor _playerColor = PlayerColor.WHITE;
  GameDifficulty _gameDifficulty = GameDifficulty.GRANDEE;

  // legacy saved times (minutes) if used elsewhere
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

  // track who moved last (helper, if needed)
  bool lastMoveWasWhite = false;

  // Clocks (nullable to avoid early access crashes)
  Clock? whitesClock;
  Clock? blacksClock;

  // === Getters ===
  bool get aiThinking => _aiThinking;
  bool get flipBoard => _flipBoard;
  int get gameLevel => _gameLevel;
  GameDifficulty get gameDifficulty => _gameDifficulty;
  int get incrementalValue => _incrementalValue;
  int get player => _player;
  PlayerColor get playerColor => _playerColor;

  int get whitesScore => _whitesScore;
  int get blacksScore => _blacksSCore;

  bishop.Game get game => _game;
  SquaresState get state => _state;

  bool get vsComputer => _vsComputer;
  bool get vsPlayer => _vsPlayer;
  bool get isLoading => _isLoading;

  // timer displays with safe fallbacks
  String get whitesTimerDisplay => whitesClock?.display() ?? '00:00';
  String get blacksTimerDisplay => blacksClock?.display() ?? '00:00';

  Duration get whitesTime => whitesClock?.currentRemaining() ?? Duration.zero;
  Duration get blacksTime => blacksClock?.currentRemaining() ?? Duration.zero;

  Duration get savedWhitesTime => _savedWhitesTime;
  Duration get savedBlacksTime => _savedBlacksTime;
  String selectedGameTime = "5+0"; // default fallback

  void setSelectedGameTime(String time) {
    selectedGameTime = time;
    notifyListeners();
  }

  // position
  getPositionFen() => game.fen;

  // === Setters / mutators ===

  void setAiThinking(bool value) {
    _aiThinking = value;
    notifyListeners();
  }

  void flipTheBoard() {
    _flipBoard = !_flipBoard;
    notifyListeners();
  }

  void setVsComputer({required bool value}) {
    _vsComputer = value;
    notifyListeners();
  }

  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  void setIncrementalValue({required int value}) {
    _incrementalValue = value;
    notifyListeners();
  }

  void setPlayerColor({required int player}) {
    _player = player;
    _playerColor =
    player == Squares.white ? PlayerColor.WHITE : PlayerColor.BLACK;
    notifyListeners();
  }

  void setGameDifficulty({required int level}) {
    _gameLevel = level;
    _gameDifficulty = level == 1
        ? GameDifficulty.GRANDEE
        : level == 2
        ? GameDifficulty.ARDASHIR
        : GameDifficulty.CAISSA;
    notifyListeners();
  }

  // legacy interface to set base times (kept)
  Future<void> setGameTime({
    required String newSavedWhitesTime,
    required String newSavedBlacksTime,
  }) async {
    _savedWhitesTime = Duration(minutes: int.parse(newSavedWhitesTime));
    _savedBlacksTime = Duration(minutes: int.parse(newSavedBlacksTime));
    notifyListeners();

    // If clocks already initialized, update them too (preserves remaining)
    if (whitesClock != null) {
      whitesClock!.remaining = _savedWhitesTime;
    }
    if (blacksClock != null) {
      blacksClock!.remaining = _savedBlacksTime;
    }
    notifyListeners();
  }

  // === Game control ===

  void resetGame({required bool newGame}) {
    if (newGame) {
      if (_player == Squares.white) {
        _player = Squares.black;
      } else {
        _player = Squares.white;
      }
    }
    _game = bishop.Game(variant: bishop.Variant.standard());
    _state = game.squaresState(_player);
    notifyListeners();
  }

  bool makeSquaresMove(Move move) {
    final result = game.makeSquaresMove(move);
    notifyListeners();
    return result;
  }

  bool makeStringMove(String bestMove) {
    final result = game.makeMoveString(bestMove);
    notifyListeners();
    return result;
  }

  Future<void> setSquaresState() async {
    _state = game.squaresState(player);
    notifyListeners();
  }

  void makeRandomMove() {
    _game.makeRandomMove();
    notifyListeners();
  }

  // === Clock / time control logic ===

  /// Lazily ensures clocks exist (fallback) to avoid 00:00 if not explicitly initialized.
  void ensureClocks({
    Duration baseTime = const Duration(minutes: 5),
    int incrementSeconds = 0,
    required BuildContext context,
    Stockfish? stockfish,
    required bool whiteStarts,
    required Function onNewGame,
  }) {
    if (whitesClock != null && blacksClock != null) return;
    initializeClocks(
      baseTime: baseTime,
      incrementSeconds: incrementSeconds,
      context: context,
      stockfish: stockfish,
      whiteStarts: whiteStarts,
      onNewGame: onNewGame,
    );
  }

  /// Initialize both clocks with base time and increment. If [whiteStarts] is true,
  /// white's clock starts immediately; otherwise black's does.
  void initializeClocks({
    required Duration baseTime,
    required int incrementSeconds,
    required BuildContext context,
    Stockfish? stockfish,
    required bool whiteStarts,
    required Function onNewGame,
  }) {
    whitesClock = Clock(
      remaining: baseTime,
      incrementSeconds: incrementSeconds,
      onTimeout: () {
        gameOverDialog(
          context: context,
          stockfish: stockfish,
          timeOut: true,
          whiteWon: false,
          onNewGame: onNewGame,
        );
      },
      onTick: notifyListeners, // 👈 triggers UI update
    );

    blacksClock = Clock(
      remaining: baseTime,
      incrementSeconds: incrementSeconds,
      onTimeout: () {
        gameOverDialog(
          context: context,
          stockfish: stockfish,
          timeOut: true,
          whiteWon: true,
          onNewGame: onNewGame,
        );
      },
      onTick: notifyListeners, // 👈 triggers UI update
    );

    if (whiteStarts) {
      whitesClock?.start();
      lastMoveWasWhite = false;
    } else {
      blacksClock?.start();
      lastMoveWasWhite = true;
    }

    notifyListeners();
  }


  /// Should be called after a move completes. [wasWhiteMove] = true if white just moved.
  void switchTurns({required bool wasWhiteMove}) {
    if (whitesClock == null || blacksClock == null) return;

    if (!kReleaseMode) {
      debugPrint('switchTurns called, wasWhiteMove: $wasWhiteMove');
      debugPrint('Before switch - white: ${whitesClock!.display()}, black: ${blacksClock!.display()}');
    }

    if (wasWhiteMove) {
      whitesClock!.stop(applyInc: true);  // ✅ Apply increment when turn ends
      blacksClock!.start();
    } else {
      blacksClock!.stop(applyInc: true);  // ✅ Apply increment when turn ends
      whitesClock!.start();
    }

    lastMoveWasWhite = wasWhiteMove;
    notifyListeners();

    if (!kReleaseMode) {
      debugPrint('After switch - white: ${whitesClock!.display()}, black: ${blacksClock!.display()}');
    }
  }

  // === Game over handling ===

  void gameOverListerner({
    required BuildContext context,
    Stockfish? stockfish,
    required Function onNewGame,
  }) {
    if (game.gameOver) {
      whitesClock?.stop();
      blacksClock?.stop();
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

  void gameOverDialog({
    required BuildContext context,
    Stockfish? stockfish,
    required bool timeOut,
    required bool whiteWon,
    required Function onNewGame,
  }) {
    if (stockfish != null && stockfish.state == StockfishState.ready) {
      stockfish.stdin = UCICommands.stop;
    }
    String resultsToShow = '';
    int whitesScoresToShow = 0;
    int blacksSCoresToShow = 0;

    if (timeOut) {
      if (whiteWon) {
        resultsToShow = 'WHITE WON ON TIME';
        whitesScoresToShow = _whitesScore + 1;
      } else {
        resultsToShow = 'BLACK WON ON TIME';
        blacksSCoresToShow = _blacksSCore + 1;
      }
    } else {
      resultsToShow = game.result!.readable;

      if (game.drawn) {
        String whitesResults = game.result!.scoreString.split('-').first;
        String blacksResults = game.result!.scoreString.split('-').last;
        whitesScoresToShow = _whitesScore += int.parse(whitesResults);
        blacksSCoresToShow = _blacksSCore += int.parse(blacksResults);
      } else if (game.winner == 0) {
        String whitesResults = game.result!.scoreString.split('-').first;
        whitesScoresToShow = _whitesScore += int.parse(whitesResults);
      } else if (game.winner == 1) {
        String blacksResults = game.result!.scoreString.split('-').last;
        blacksSCoresToShow = _blacksSCore += int.parse(blacksResults);
      } else if (game.stalemate) {
        whitesScoresToShow = whitesScore;
        blacksSCoresToShow = blacksScore;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'GAME OVER\n $whitesScoresToShow - $blacksSCoresToShow',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          resultsToShow,
          style: GoogleFonts.lato(),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Constants.gameTimeScreen,
                    (route) => false,
              );
            },
            child: Text(
              'TRY AGAIN',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 28, 36, 41),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cleanup
  @override
  void dispose() {
    try {
      whitesClock?.dispose();
    } catch (_) {}
    try {
      blacksClock?.dispose();
    } catch (_) {}
    super.dispose();
  }
}
