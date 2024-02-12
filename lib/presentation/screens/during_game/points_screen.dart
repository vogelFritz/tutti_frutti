import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/models/user.dart';
import '../../providers/providers.dart';

class PointsScreen extends ConsumerWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sala sala = ref.watch(salaProvider)!;
    final fields = ref.watch(fieldProvider);
    final size = MediaQuery.of(context).size;
    ref.listen(salaProvider, (_, next) {
      if (next!.allReady) {
        context.push('/game');
      }
    });
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Nombre - Puntos'),
            ...sala.jugadores.map((User user) =>
                Text('${user.nombre}: ${user.points.toString()}')),
          ]),
          SizedBox(
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
                      leading: Text(
                          jugador.fieldValues[fields[i]]!.points.toString()),
                      title: Text(
                          '${jugador.nombre}: ${jugador.fieldValues[fields[i]]!.answer}'),
                      trailing: IconButton(
                        onPressed: () {
                          ref.read(salasProvider.notifier).update((state) {
                            var stateCopy = {...state};
                            final auxSala = sala;
                            var j = 0;
                            while (j < auxSala.jugadores.length &&
                                auxSala.jugadores[j].nombre != jugador.nombre) {
                              j++;
                            }
                            if (j < auxSala.jugadores.length) {
                              auxSala.jugadores[j].fieldValues = {
                                ...auxSala.jugadores[j].fieldValues,
                                fields[i]: auxSala
                                    .jugadores[j].fieldValues[fields[i]]!
                                    .copyWith(points: 0),
                              };
                            }
                            stateCopy[auxSala.nombre] = auxSala;
                            return stateCopy;
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ));
                })
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref
                .read(userProvider.notifier)
                .update((state) => state.copyWith(ready: true));
          },
          child: Container(
              margin: const EdgeInsets.all(8.0),
              child: const Text('Continuar'))),
    );
  }
}
