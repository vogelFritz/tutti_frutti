import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/config/constants/environment.dart';
import 'package:tutti_frutti/models/sala.dart';

final socketProvider = ChangeNotifierProvider<SocketNotifier>((ref) {
  return SocketNotifier();
});

enum ServerStatus { online, offline, connecting }

class SocketNotifier extends ChangeNotifier {
  late Socket _socket;
  String nombre = '';
  final List<String> _eventNames = [];
  final Map<String, Function> _events = {};
  List<Sala> salas = [];
  Sala? salaSeleccionada;
  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket;

  SocketNotifier() {
    onEvent('salaCreada', (nombreSala) {
      salas.add(Sala(nombre: nombreSala));
      notifyListeners();
    });
    onEvent('unirse', (salasJson) {
      final decodedPlayers = jsonDecode(salasJson);
      print(decodedPlayers);
      decodedPlayers.forEach(
          (player) => salaSeleccionada!.jugadores.add(player['nombre']));
    });
    connect();
  }
  void connect() async {
    try {
      if (Environment.host != null && Environment.port != null) {
        _socket = await Socket.connect(
            Environment.host!, int.parse(Environment.port!));
      }
      _serverStatus = ServerStatus.online;
      notifyListeners();
      _socket.listen((data) {
        _parseData(data);
      });
    } catch (e) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    }
  }

  _parseData(Uint8List data) {
    String mensaje = '';
    for (int caracter in data) {
      mensaje += String.fromCharCode(caracter);
    }
    for (String eventName in _eventNames) {
      if (mensaje.contains(eventName)) {
        final data = mensaje.substring(eventName.length);
        _events[eventName]!(data);
      }
    }
  }

  void onEvent(String event, Function(String data) handler) {
    _eventNames.add(event);
    _events[event] = handler;
  }

  void emitEvent(String event, [String? data]) {
    final finalMessage = (data != null) ? event + data : event;
    _socket.write(finalMessage);
  }
}
