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
    } catch (e) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    }
  }
}
