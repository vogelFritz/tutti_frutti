import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/presentation/providers/socket_provider.dart';

class WaitingScreen extends ConsumerWidget {
  static String name = 'waiting_screen';
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sala sala = ref.watch(socketProvider).salaSeleccionada!;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: 600,
          width: 300,
          color: Colors.blueGrey,
          child: Column(
            children: [
              Text(ref.read(socketProvider.notifier).salaSeleccionada!.nombre),
              SingleChildScrollView(
                child: SizedBox(
                  height: 400,
                  width: 300,
                  child: ListView.builder(
                      itemCount: sala.jugadores.length,
                      itemBuilder: (_, i) {
                        final jugador = sala.jugadores[i];
                        return ListTile(title: Text(jugador));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
