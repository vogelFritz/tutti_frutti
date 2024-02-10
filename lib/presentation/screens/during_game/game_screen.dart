import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tutti_frutti/presentation/providers/providers.dart';
import 'package:tutti_frutti/presentation/widgets/buttons.dart';

class GameScreen extends ConsumerWidget {
  static const String name = 'game';
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayLarge = Theme.of(context).textTheme.displayLarge;
    final currentLetter = ref.watch(letterProvider);
    final fields = ref.watch(fieldProvider);
    ref.listen(gameStateProvider, (_, next) {
      if (next == GameState.countingPoints) {
        context.push('points_screen');
      }
    });
    return Scaffold(
      body: Stack(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 0, 40),
              child: _CustomColumn(fields: fields),
            )),
        Align(
            alignment: Alignment.topRight,
            child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff616975),
                  border: Border.all(color: Colors.yellowAccent, width: 2.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 5),
                        color: Colors.lightGreenAccent,
                        shape: BoxShape.circle,
                      ),
                      width: 100,
                      height: 100,
                      child: Text(currentLetter,
                          style: displayLarge!.copyWith(color: Colors.black)),
                    ),
                    GestureDetector(
                        onTap: () {
                          ref.read(socketProvider.notifier).emitEvent('stop');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 2.0)),
                        )),
                  ],
                ))),
      ]),
      floatingActionButton: const GoBackButton(),
    );
  }
}

class _CustomColumn extends ConsumerWidget {
  final List<String> fields;
  const _CustomColumn({required this.fields});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displaySmallTextStyle = Theme.of(context).textTheme.displaySmall;
    return SingleChildScrollView(
      child: Column(
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
                          border: const OutlineInputBorder()),
                      onChanged: (value) => ref
                          .read(userProvider.notifier)
                          .update((state) => state.copyWith(fieldValues: {
                                ...state.fieldValues,
                                field: value
                              })),
                    )),
              ))
        ],
      ),
    );
  }
}
