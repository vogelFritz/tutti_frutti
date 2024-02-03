import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/presentation/providers/providers.dart';
import '../../../models/models.dart';

class WaitingScreen extends ConsumerWidget {
  static String name = 'waiting_screen';
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sala sala = ref.watch(salaProvider)!;
    final User user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          children: [
            Text(sala.nombre),
            SingleChildScrollView(
              child: SizedBox(
                height: 300,
                width: 300,
                child: ListView.builder(
                    itemCount: sala.jugadores.length,
                    itemBuilder: (_, i) {
                      final jugador = sala.jugadores[i];
                      return ListTile(
                        leading: IconButton(
                            onPressed: user.nombre == jugador.nombre
                                ? () {
                                    ref
                                        .read(socketProvider.notifier)
                                        .emitEvent('ready', user.nombre);
                                  }
                                : null,
                            icon: jugador.ready
                                ? const Icon(Icons.check,
                                    color: Colors.greenAccent)
                                : const Icon(Icons.check)),
                        title: Text(jugador.nombre),
                      );
                    }),
              ),
            ),
            const FieldSuggestions(),
            sala.host.nombre == user.nombre
                ? TextButton(
                    onPressed: sala.allReady
                        ? () {
                            ref.read(fieldProvider.notifier).update((_) => ref
                                .read(fieldSuggestionsProvider.notifier)
                                .mostVotedFields);
                            // TODO: Ir a la pantalla de la partida
                          }
                        : null,
                    child: const Text('Empezar partida'),
                  )
                : const Text('Espere a que el host comience la partida'),
          ],
        ),
      ),
    );
  }
}

class FieldSuggestions extends ConsumerStatefulWidget {
  const FieldSuggestions({super.key});

  @override
  ConsumerState<FieldSuggestions> createState() => _FieldSuggestionsState();
}

class _FieldSuggestionsState extends ConsumerState<FieldSuggestions> {
  late Suggestion _newSuggestion;
  @override
  void initState() {
    _newSuggestion =
        Suggestion(fields: [], userName: ref.read(userProvider).nombre);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();
    final fieldSuggestions = ref.watch(fieldSuggestionsProvider);
    return Column(children: [
      TextField(
        controller: textController,
        focusNode: focusNode,
        onSubmitted: (value) {
          if (textController.text.isNotEmpty) {
            setState(() {
              focusNode.requestFocus();
              _newSuggestion.fields.add(value);
            });
          }
        },
      ),
      Row(children: [
        ..._newSuggestion.fields.map((field) => Text('$field --- ')),
        IconButton(
          onPressed: () {
            ref.read(socketProvider.notifier).emitEvent(
                'fieldSuggestion', jsonEncode(_newSuggestion.toJson()));
            setState(() {
              textController.clear();
              focusNode.unfocus();
            });
          },
          icon: const Icon(Icons.arrow_forward),
        )
      ]),
      ...fieldSuggestions.values.map((suggestion) => GestureDetector(
            onTap: () {
              ref.read(socketProvider.notifier).emitEvent(
                  'voted',
                  jsonEncode({
                    'voter': ref.read(userProvider).nombre,
                    'vote': suggestion.userName,
                  }));
            },
            child: ListTile(
              title: Row(children: [
                ...suggestion.fields.map((field) => Text('$field --- '))
              ]),
              subtitle: Text(suggestion.userName),
              trailing: Text(suggestion.votes.toString()),
            ),
          )),
    ]);
  }
}
