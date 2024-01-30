import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/presentation/providers/socket_provider.dart';

class SalasDialog extends ConsumerStatefulWidget {
  const SalasDialog({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalasDialogState();
}

class _SalasDialogState extends ConsumerState<SalasDialog> {
  @override
  Widget build(BuildContext context) {
    final socket = ref.watch(socketProvider);
    return AlertDialog(
      title: const Text('Salas disponibles'),
      content: Row(
        children: [
          ...socket.salas
              .map((Sala sala) => TextButton(
                    onPressed: () {
                      //sala.jugadores.add(socket.nombre);
                      socket.emitEvent('unirse', jsonEncode(sala));
                      socket.salaSeleccionada = sala;
                      context.push('/waiting_screen');
                    },
                    child: Text(sala.nombre),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
