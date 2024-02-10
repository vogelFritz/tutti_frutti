import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutti_frutti/models/sala.dart';

import '../../providers/providers.dart';

class PointsScreen extends ConsumerWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sala sala = ref.watch(salaProvider)!;
    final fields = ref.watch(fieldProvider);
    return Scaffold(
      body: Expanded(
        child: ListView.builder(
          itemCount: fields.length,
          itemBuilder: (_, i) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: ListView.builder(
                itemCount: sala.jugadores.length,
                itemBuilder: (_, i) {
                  final jugador = sala.jugadores[i];
                  return ListTile(
                      title: Text(
                          '${jugador.nombre}: ${jugador.fieldValues[fields[i]]}'));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
