import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/providers/field_provider.dart';
import 'package:tutti_frutti/presentation/screens.dart';

class GameStartScreen extends ConsumerWidget {
  static const String name = 'game_start';
  const GameStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text('Comenzar Partida')),
        body: Column(children: [
          TextField(
            onSubmitted: (value) {
              ref.read(fieldProvider.notifier).state.add(value);
            },
          ),
          Consumer(builder: (context, ref, _) {
            final updatedFields = ref.watch(fieldProvider);
            return Wrap(
                spacing: 10,
                children: [...updatedFields.map((field) => Text(field))]);
          }),
          FilledButton(
              onPressed: () {
                context.pushNamed(GameScreen.name);
              },
              child: const Text('Listo'))
        ]));
  }
}
