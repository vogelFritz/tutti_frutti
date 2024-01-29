import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          ...socket.nombresSalas.map((nombreSala) => Text(nombreSala)).toList(),
        ],
      ),
    );
  }
}
