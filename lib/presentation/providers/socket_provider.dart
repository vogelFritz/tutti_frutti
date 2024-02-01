import 'dart:convert';
import 'dart:typed_data';

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/config/constants/environment.dart';
import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/models/user.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

final socketProvider =
    StateNotifierProvider<SocketNotifier, SocketState>((ref) {
  final user = ref.watch(userProvider);
  final salas = ref.watch(salasProvider);
  return SocketNotifier(user, salas);
});

enum ServerStatus { online, offline, connecting }

class SocketNotifier extends StateNotifier<SocketState> {
  User user;
  List<Sala> salas;

  SocketNotifier(this.user, this.salas) : super(SocketState()) {
    onEvent('nuevaSala', (nombreSala) {
      salas.add(Sala(nombre: nombreSala));
    });
    onEvent('unirse', (salasJson) {
      final decodedPlayers = jsonDecode(salasJson);
      decodedPlayers
          .forEach((player) => user.sala!.jugadores.add(player['nombre']));
    });
    connect();
  }
  void connect() async {
    try {
      if (Environment.host != null && Environment.port != null) {
        state.socket = await Socket.connect(
            Environment.host!, int.parse(Environment.port!));
      }
      state = state.copyWith(
          serverStatus: ServerStatus.online, socket: state.socket);
      state.socket.listen(
        (data) {
          _parseData(data);
        },
        onError: (error) {},
      );
    } catch (e) {
      state = state.copyWith(
          serverStatus: ServerStatus.offline, socket: state.socket);
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
    state.socket.write(finalMessage);
  }
}

class SocketState {
  final List<String> eventNames;
  final Map<String, Function> events;
  late Socket socket;
  final ServerStatus serverStatus;

  SocketState({
    this.eventNames = const [],
    this.events = const {},
    Socket? socket,
    this.serverStatus = ServerStatus.connecting,
  }) {
    if (socket != null) {
      this.socket = socket;
    }
  }

  SocketState copyWith({
    List<String>? eventNames,
    Map<String, Function>? events,
    Socket? socket,
    ServerStatus? serverStatus,
  }) =>
      SocketState(
        eventNames: eventNames ?? this.eventNames,
        events: events ?? this.events,
        socket: socket,
        serverStatus: serverStatus ?? this.serverStatus,
      );
}
