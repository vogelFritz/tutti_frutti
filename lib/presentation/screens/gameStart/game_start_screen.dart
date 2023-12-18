import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/screens.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onSubmitted: (value) {
                  agregarColumna(value);
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                  onPressed: () {
                    context.pushNamed(GameScreen.name);
                  },
                  child: const Text('Listo')),
              ...columnas.map((col) => ListTile(
                  leading: const Icon(Icons.data_array_sharp),
                  title: Text(col)))
            ],
          ),
        ));
  }
}
