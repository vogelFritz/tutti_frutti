import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/config/constants/environment.dart';
import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

final socketProvider =
    StateNotifierProvider<SocketNotifier, SocketState>((ref) {
  return SocketNotifier(ref);
});

enum ServerStatus { online, offline, connecting }

class SocketNotifier extends StateNotifier<SocketState> {
  final StateNotifierProviderRef<SocketNotifier, SocketState> ref;
  late Socket _socket;

  SocketNotifier(this.ref) : super(SocketState()) {
    onEvent('nuevaSala', (salaJsonString) {
      final salaJson = jsonDecode(salaJsonString);
      final sala = Sala.fromJson(salaJson);
      ref.read(salasProvider.notifier).update((state) => [...state, sala]);
      ref
          .read(userProvider.notifier)
          .update((state) => state.copyWith(sala: sala));
    });
    onEvent('unirse', (newPlayer) {
      ref.read(userProvider.notifier).update((state) => state.copyWith(
          sala: Sala(
              nombre: state.sala!.nombre,
              jugadores: [...state.sala!.jugadores, newPlayer])));
      ref.read(salasProvider.notifier).update((state) {
        final aux = [...state];
        Sala sala = ref.read(userProvider).sala!;
        final i = aux.indexWhere((s) => s.nombre == sala.nombre);
        aux[i] = sala;
        return aux;
      });
    });
    connect();
  }
  void connect() async {
    try {
      if (Environment.host != null && Environment.port != null) {
        _socket = await Socket.connect(
            Environment.host!, int.parse(Environment.port!));
      }
      state = state.copyWith(serverStatus: ServerStatus.online);
      _socket.listen(
        (data) {
          _parseData(data);
        },
        onError: (error) {},
      );
    } catch (e) {
      state = state.copyWith(serverStatus: ServerStatus.offline);
    }
  }

  _parseData(Uint8List data) {
    String mensaje = '';
    for (int caracter in data) {
      mensaje += String.fromCharCode(caracter);
    }
    for (String eventName in state.eventNames) {
      if (mensaje.contains(eventName)) {
        final parsedData = mensaje.substring(eventName.length);
        state.events[eventName]!(parsedData);
      }
    }
  }

  void onEvent(String event, Function(String data) handler) {
    state = state.copyWith(eventNames: [
      ...state.eventNames,
      event
    ], events: <String, Function>{
      ...state.events,
      event: handler,
    });
  }

  void emitEvent(String event, [String? data]) {
    final finalMessage = (data != null) ? event + data : event;
    _socket.write(finalMessage);
  }
}

class SocketState {
  final List<String> eventNames;
  final Map<String, Function> events;
  final ServerStatus serverStatus;

  SocketState({
    this.eventNames = const [],
    this.events = const {},
    this.serverStatus = ServerStatus.connecting,
  });

  SocketState copyWith({
    List<String>? eventNames,
    Map<String, Function>? events,
    Socket? socket,
    ServerStatus? serverStatus,
  }) =>
      SocketState(
        eventNames: eventNames ?? this.eventNames,
        events: events ?? this.events,
        serverStatus: serverStatus ?? this.serverStatus,
      );
}
