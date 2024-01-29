import 'package:flutter/material.dart';
import 'package:tutti_frutti/presentation/widgets/widgets.dart';

class GameOptionsScreen extends StatelessWidget {
  static String name = 'game_options';
  const GameOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MaterialButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const NewRoomDialog(),
              );
            },
            color: Colors.orangeAccent,
            child: const Text('Abrir sala')),
        MaterialButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const SalasDialog(),
              );
            },
            color: Colors.orangeAccent,
            child: const Text('Unirse')),
      ])),
    );
  }
}
