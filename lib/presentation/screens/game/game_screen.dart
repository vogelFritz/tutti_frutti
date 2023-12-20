import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import 'package:tutti_frutti/presentation/providers/field_provider.dart';

class GameScreen extends ConsumerWidget {
  static const String name = 'game';
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alphabet =
        List.generate(26, (index) => String.fromCharCode(index + 65));
    final random = Random();
    final fields = ref.watch(fieldProvider);
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
              child: Text(alphabet[random.nextInt(alphabet.length)],
                  style: const TextStyle(fontSize: 30))),
        ),
        _Columns(fields: fields),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pop();
          },
          child: const Icon(Icons.arrow_back_sharp)),
    );
  }
}

class _Columns extends StatelessWidget {
  final List<dynamic> fields;
  const _Columns({required this.fields});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...fields.map((field) => Column(
            children: [
              Text(field),
              SizedBox(width: 50, height: 20, child: const TextField())
            ],
          ))
    ]);
  }
}
