import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tutti_frutti/presentation/providers/field_provider.dart';
import 'package:tutti_frutti/presentation/screens.dart';
import 'package:tutti_frutti/presentation/widgets/buttons.dart';

class GameStartScreen extends ConsumerStatefulWidget {
  static const String name = 'game_start';

  const GameStartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameStartState();
}

class GameStartState extends ConsumerState<GameStartScreen> {
  @override
  void initState() {
    ref.read(fieldProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultValues = ['Nombres', 'Frutas', 'Comida', 'Países', 'Colores'];
    final textController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 60,
            width: 200,
            child: TextField(
              controller: textController,
              onSubmitted: (value) {
                ref.read(fieldProvider.notifier).state.add(value);
                textController.clear();
                setState(() {});
                //textController.notifyListeners();
              },
            ),
          ),
          Consumer(builder: (context, ref, _) {
            final updatedFields = ref.watch(fieldProvider);
            return Wrap(spacing: 10, children: [
              ...updatedFields.map((field) => Text(field)),
              (updatedFields.isNotEmpty)
                  ? IconButton(
                      onPressed: () {
                        ref.read(fieldProvider.notifier).state.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete))
                  : const SizedBox()
            ]);
          }),
          FilledButton(
              onPressed: () {
                context.pushNamed(GameScreen.name);
              },
              child: const Text('Listo')),
          TextButton(
              onPressed: () {
                ref.read(fieldProvider.notifier).state = defaultValues;
              },
              child: Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(defaultValues.join(' - '))],
                ),
              ))
        ]),
      ),
      floatingActionButton: const GoBackButton(),
    );
  }
}
