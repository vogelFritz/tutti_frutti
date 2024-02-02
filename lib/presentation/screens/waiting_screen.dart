import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/models/user.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

class WaitingScreen extends ConsumerWidget {
  static String name = 'waiting_screen';
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sala sala = ref.watch(salaProvider)!;
    final User user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          children: [
            Text(sala.nombre),
            SingleChildScrollView(
              child: SizedBox(
                height: 400,
                width: 300,
                child: ListView.builder(
                    itemCount: sala.jugadores.length,
                    itemBuilder: (_, i) {
                      final jugador = sala.jugadores[i];
                      return ListTile(
                        leading: IconButton(
                            onPressed: user.nombre == jugador.nombre
                                ? () {
                                    ref
                                        .read(socketProvider.notifier)
                                        .emitEvent('ready', user.nombre);
                                  }
                                : null,
                            icon: jugador.ready
                                ? const Icon(Icons.check,
                                    color: Colors.greenAccent)
                                : const Icon(Icons.check)),
                        title: Text(jugador.nombre),
                      );
                    }),
              ),
            ),
            sala.host.nombre == user.nombre
                ? TextButton(
                    onPressed: sala.allReady ? () {} : null,
                    child: const Text('Empezar partida'),
                  )
                : const Text('Espere a que el host comience la partida'),
          ],
        ),
      ),
    );
  }
}
