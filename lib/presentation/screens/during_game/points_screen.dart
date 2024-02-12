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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height * 0.9,
        width: size.width * 0.9,
        child: ListView.builder(
          itemCount: fields.length,
          itemBuilder: (_, i) =>
              Column(mainAxisSize: MainAxisSize.min, children: [
            Text(fields[i]),
            ...sala.jugadores.map((jugador) {
              if (jugador.fieldValues[fields[i]] == null) {
                return const Text('Sin respuesta');
              }
              return ListTile(
                  leading:
                      Text(jugador.fieldValues[fields[i]]!.points.toString()),
                  title: Text(
                      '${jugador.nombre}: ${jugador.fieldValues[fields[i]]!.answer}'));
            })
          ]),
          //ListView.builder(
          //  itemCount: sala.jugadores.length,
          //  itemBuilder: (_, j) {
          //    final jugador = sala.jugadores[j];
          //    return ListTile(
          //        title: Text(
          //            '${jugador.nombre}: ${jugador.fieldValues[fields[i]]}'));
          //  },
          //),
        ),
      ),
    );
  }
}
