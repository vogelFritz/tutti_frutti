import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

class SalasDialog extends ConsumerStatefulWidget {
  const SalasDialog({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalasDialogState();
}

class _SalasDialogState extends ConsumerState<SalasDialog> {
  @override
  Widget build(BuildContext context) {
    final salas = ref.watch(salasProvider);
    final user = ref.watch(userProvider);
    return AlertDialog(
      title: const Text('Salas disponibles'),
      content: Row(
        children: [
          ...salas
              .map((Sala sala) => TextButton(
                    onPressed: () {
                      ref.read(socketProvider.notifier).emitEvent(
                          'unirse',
                          jsonEncode({
                            "room": sala.nombre,
                            "player": user.nombre,
                          }));
                      user.sala = sala;
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
