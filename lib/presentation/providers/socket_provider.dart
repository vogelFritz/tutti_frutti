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
    });
    onEvent('newLetter', (letter) {
      // TODO: Investigar bug, letter llega con el nombre del evento
      ref
          .read(letterProvider.notifier)
          .update((_) => letter.substring(letter.length - 1));
      print(letter);
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

  _parseData(Uint8List data) {
    String mensaje = '';
    for (int caracter in data) {
      mensaje += String.fromCharCode(caracter);
    }
    final String receivedEvent = _events.keys.firstWhere(
        (eventName) => mensaje.contains(eventName),
        orElse: () => 'not-found');
    if (receivedEvent != 'not-found') {
      final parsedData = mensaje.substring(receivedEvent.length);
      _events[receivedEvent]!(parsedData);
    } else {
      throw EventNotFound();
    }
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
