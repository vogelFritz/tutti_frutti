import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/providers/socket_provider.dart';

class NewRoomDialog extends ConsumerWidget {
  const NewRoomDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textController = TextEditingController();
    return AlertDialog(
      title: const Text('Nombre de la sala'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(hintText: 'Sala de Juan'),
        onChanged: (input) {
          textController.text = input;
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            ref
                .read(socketProvider)
                .sendMessageToServer('nuevaSala:${textController.text}');
            context.push('/waiting_screen');
          },
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }
}
