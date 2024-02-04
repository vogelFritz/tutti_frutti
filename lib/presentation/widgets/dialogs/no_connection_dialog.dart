import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/providers/providers.dart';

class NoConnectionDialog extends ConsumerStatefulWidget {
  const NoConnectionDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NoConnectionDialogState();
}

class NoConnectionDialogState extends ConsumerState<NoConnectionDialog> {
  bool connecting = false;
  @override
  Widget build(BuildContext context) {
    ref.listen(socketProvider, (_, next) {
      if (next == ServerStatus.online) {
        context.pop();
      }
    });
    return AlertDialog(
      title: const Text('Fallo con la conexión'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Reintentar'),
        IconButton(
            onPressed: () async {
              setState(() {
                connecting = true;
              });
              await ref.read(socketProvider.notifier).connect();
              setState(() {
                connecting = false;
              });
            },
            icon: connecting
                ? const CircularProgressIndicator()
                : const Icon(Icons.refresh_rounded)),
      ]),
    );
  }
}
