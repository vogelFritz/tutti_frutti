import 'package:flutter/material.dart';

class GameStartScreen extends StatefulWidget {
  static const String name = 'game_start';
  const GameStartScreen({super.key});

  @override
  State<GameStartScreen> createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen> {
  List<String> columnas = [];

  void agregarColumna(String col) {
    columnas.add(col);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Comenzar Partida')),
        body: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                agregarColumna(value);
              },
            ),
            ...columnas.map((col) => Text(col))
          ],
        ));
  }
}
