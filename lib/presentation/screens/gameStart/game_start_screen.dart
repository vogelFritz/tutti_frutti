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
    final fields = ref.watch(fieldProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Comenzar Partida')),
        body: ListView.builder(
            itemCount: fields.length + 2,
            itemBuilder: (context, index) {
              return (index == 0)
                  ? TextField(
                      onSubmitted: (value) {
                        ref.read(fieldProvider.notifier).state.add(value);
                      },
                    )
                  : (index < fields.length + 1)
                      ? ListTile(title: Text(fields[index - 1]))
                      : FilledButton(
                          onPressed: () {
                            context.pushNamed(GameScreen.name);
                          },
                          child: const Text('Listo'));
            }));
  }
}
