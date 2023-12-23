import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:tutti_frutti/presentation/providers/field_provider.dart';
import 'package:tutti_frutti/presentation/widgets/buttons.dart';

class GameScreen extends ConsumerWidget {
  static const String name = 'game';
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayLarge = Theme.of(context).textTheme.displayLarge;
    final alphabet =
        List.generate(26, (index) => String.fromCharCode(index + 65));
    final random = Random();
    final fields = ref.watch(fieldProvider);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 0, 40),
              child: _CustomColumn(fields: fields),
            )),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(alphabet[random.nextInt(alphabet.length)],
                  style: displayLarge),
            )),
      ]),
      floatingActionButton: const GoBackButton(),
    );
  }
}

class _CustomColumn extends StatelessWidget {
  final List<String> fields;
  const _CustomColumn({required this.fields});

  @override
  Widget build(BuildContext context) {
    final displaySmallTextStyle = Theme.of(context).textTheme.displaySmall;
    return Column(
      children: [
        ...fields.map((field) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: SizedBox(
                  width: 400,
                  height: 60,
                  child: TextField(
                      decoration: InputDecoration(
                          label: Text(field, style: displaySmallTextStyle),
                          filled: true,
                          border: const OutlineInputBorder()))),
            ))
      ],
    );
  }
}
