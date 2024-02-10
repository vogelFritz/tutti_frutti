import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/config/constants/environment.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

import '../../models/models.dart';

final socketProvider =
    StateNotifierProvider<SocketNotifier, ServerStatus>((ref) {
  return SocketNotifier(ref);
});

enum ServerStatus { online, offline, connecting }

class SocketNotifier extends StateNotifier<ServerStatus> {
  final StateNotifierProviderRef<SocketNotifier, ServerStatus> ref;
  late Socket _socket;
  final Map<String, Function> _events = {};

  SocketNotifier(this.ref) : super(ServerStatus.connecting) {
    onEvent('nuevaSala', (salaJsonString) {
      final salaJson = jsonDecode(salaJsonString);
      final sala = Sala.fromJson(salaJson);
      ref
          .read(salasProvider.notifier)
          .update((state) => {...state, sala.nombre: sala});
      ref
          .read(userProvider.notifier)
          .update((state) => state.copyWith(sala: sala.nombre));
    });
    onEvent('unirse', (newPlayer) {
      ref.read(salasProvider.notifier).update((state) {
        final aux = {...state};
        String nombreSala = ref.read(userProvider).sala!;
        if (aux[nombreSala] != null) {
          aux[nombreSala]!.jugadores.add(User(nombre: newPlayer));
        }
        return aux;
      });
    });
    onEvent('ready', (playerName) {
      final String nombreSala = ref.read(salaProvider)!.nombre;
      ref.read(salasProvider.notifier).update((state) {
        final aux = {...state};
        int i = 0;
        while (aux[nombreSala]!.jugadores[i].nombre != playerName) {
          i++;
        }
        if (aux[nombreSala]!.jugadores[i].nombre == playerName) {
          aux[nombreSala]!.jugadores[i].ready = true;
        }
        return aux;
      });
    });
    onEvent('fieldSuggestion', (fieldsSuggestion) {
      final Map<String, dynamic> fieldsSuggestionJson =
          jsonDecode(fieldsSuggestion);
      final suggestion = Suggestion.fromJson(fieldsSuggestionJson);

      ref.read(fieldSuggestionsProvider.notifier).newSuggestion(suggestion);
    });
    onEvent('voted', (voteData) {
      final Map<String, dynamic> voteDataJson = jsonDecode(voteData);
      ref
          .read(fieldSuggestionsProvider.notifier)
          .onVote(voteDataJson['voter'], voteDataJson['vote']);
    });
    onEvent('startGame', (_) {
      ref.read(fieldProvider.notifier).update(
          (_) => ref.read(fieldSuggestionsProvider.notifier).mostVotedFields);
      ref.read(gameStateProvider.notifier).update((_) => GameState.inGame);
    });
    onEvent('newLetter', (letter) {
      ref
          .read(letterProvider.notifier)
          .update((_) => letter.substring(letter.length - 1));
    });
    onEvent('stop', (letter) {
      final User user = ref.read(userProvider);
      final userFieldValuesMap = {
        'user': user.nombre,
        'fieldValues': user.fieldValues,
      };
      emitEvent(
        'userFieldValues',
        jsonEncode(userFieldValuesMap),
      );
      ref
          .read(gameStateProvider.notifier)
          .update((_) => GameState.countingPoints);
    });
    onEvent('userFieldValues', (userFieldValues) {
      final User user = ref.read(userProvider);
      final userFieldValuesMap = jsonDecode(userFieldValues);
      ref.read(salasProvider.notifier).update((state) {
        var stateCopy = {...state};
        final Sala sala = stateCopy[user.sala!]!;
        String userName = userFieldValuesMap['user'];
        var i = 0;
        while (
            i < sala.jugadores.length && sala.jugadores[i].nombre != userName) {
          i++;
        }
        if (i < sala.jugadores.length) {
          sala.jugadores[i].fieldValues = userFieldValuesMap['fieldValues'];
        }
        stateCopy[user.sala!] = sala;
        return stateCopy;
      });
    });
    connect();
  }

  Future<void> connect() async {
    try {
      if (Environment.host != null && Environment.port != null) {
        _socket = await Socket.connect(
            Environment.host!, int.parse(Environment.port!));
      }
      state = ServerStatus.online;
      _socket.listen(
        (data) {
          _parseData(data);
        },
        onError: (error) {},
      );
    } catch (e) {
      state = ServerStatus.offline;
    }
  }

  void _parseData(Uint8List data) {
    String mensaje = '';
    for (int caracter in data) {
      mensaje += String.fromCharCode(caracter);
    }

    List<String> eventsFound = [];
    List<int> eventPositions = [];
    for (String eventName in _events.keys) {
      if (mensaje.contains(eventName)) {
        eventsFound.add(eventName);
        eventPositions.add(_indexOfString(mensaje, eventName));
      }
    }

    for (int i = 0; i < eventPositions.length - 1; i++) {
      final currentEventName = eventsFound[i];
      final parsedData = mensaje.substring(
          eventPositions[i] + currentEventName.length, eventPositions[i + 1]);
      _events[currentEventName]!(parsedData);
    }
    _events[eventsFound.last]!(
        mensaje.substring(eventPositions.last + eventsFound.last.length));
  }

  int _indexOfString(String source, String str) {
    if (source.isEmpty || str.isEmpty) {
      throw Exception(
          'indexOfString used incorrectly - neither "source" nor "str" can be empty strings');
    }
    String aux = source[0];
    int i = 0;
    while (i < source.length - 1 && !aux.contains(str)) {
      i++;
      aux += source[i];
    }
    if (i < source.length) {
      return i - (str.length - 1);
    }
    return -1;
  }

  void onEvent(String event, Function(String data) handler) {
    _events[event] = handler;
  }

  void emitEvent(String event, [String? data]) {
    final finalMessage = (data != null) ? event + data : event;
    _socket.write(finalMessage);
  }
}

class EventNotFound implements Exception {
  final String? event;
  EventNotFound([this.event]);
}
