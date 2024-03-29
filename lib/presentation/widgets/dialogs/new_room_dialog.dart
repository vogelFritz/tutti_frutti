import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/models/sala.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

class NewRoomDialog extends ConsumerWidget {
  const NewRoomDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final TextEditingController textController = TextEditingController();

    ref.listen(salaProvider, (_, next) {
      if (next != null) {
        context.go('/waiting_screen');
      }
    });

    return AlertDialog(
      title: const Text('Nombre de la sala'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(hintText: 'Sala de Juan'),
      ),
      actions: [
        IconButton(
          onPressed: () {
            final sala = Sala(
                nombre: textController.text, host: user, jugadores: [user]);
            ref
                .read(socketProvider.notifier)
                .emitEvent('nuevaSala', jsonEncode(sala.toJson()));
            user.sala = sala.nombre;
          },
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }
}
