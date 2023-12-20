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
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onSubmitted: (value) {
                  ref.read(fieldProvider.notifier).state.add(value);
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                  onPressed: () {
                    context.pushNamed(GameScreen.name);
                  },
                  child: const Text('Listo')),
              //SingleChildScrollView(
              //  child: ListView.builder(
              //      itemBuilder: (context, index) => ListTile(
              //          leading: const Icon(Icons.data_array_sharp),
              //          title: Text(fields[index]))),
              //)
              ...fields.map((field) => ListTile(
                  leading: const Icon(Icons.data_array_sharp),
                  title: Text(field)))
            ],
          ),
        ));
  }
}
