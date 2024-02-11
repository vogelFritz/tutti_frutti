import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';
import 'package:tutti_frutti/presentation/widgets/widgets.dart';

class GameOptionsScreen extends ConsumerWidget {
  static String name = 'game_options';
  const GameOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back))),
      body: Center(
          child: SizedBox(
        height: 300,
        width: 500,
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 150,
              child: CustomTextField(
                label: 'Tu nombre',
                hintText: 'Juan',
                onChanged: (value) => ref.read(userProvider.notifier).update((state) => state.copyWith(nombre: value)),
              ),
            ),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              MaterialButton(
                  onPressed: user.nombre.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (_) => const NewRoomDialog(),
                          );
                        },
                  color: Colors.orangeAccent,
                  child: const Text('Abrir sala')),
              MaterialButton(
                  onPressed: user.nombre.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (_) => const SalasDialog(),
                          );
                        },
                  color: Colors.orangeAccent,
                  child: const Text('Unirse')),
            ]),
          ],
        ),
      )),
    );
  }
}
