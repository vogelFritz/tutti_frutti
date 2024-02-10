import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GameState { preparing, inGame, countingPoints }

final gameStateProvider = StateProvider<GameState>((_) => GameState.preparing);
