import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/config/constants/environment.dart';

final socketProvider = ChangeNotifierProvider<SocketNotifier>((ref) {
  return SocketNotifier();
});

enum ServerStatus { online, offline, connecting }

class SocketNotifier extends ChangeNotifier {
  late Socket _socket;
  String nombre = '';
  List<String> nombresSalas = [];
  List<String> usuariosUnidos = [];
  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket;

  SocketNotifier() {
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
    if (mensaje.contains('salaCreada:')) {
      nombre = mensaje.substring(11);
      nombresSalas.add(nombre);
    }
  }

  void sendMessageToServer(String message) {
    _socket.write(message);
  }
}
