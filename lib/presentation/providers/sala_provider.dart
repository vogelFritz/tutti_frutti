import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutti_frutti/models/sala.dart';
import 'providers.dart';

final salaProvider = StateProvider<Sala?>((ref) {
  final nombreSala = ref.watch(userProvider).sala;
  final sala = ref.watch(salasProvider)[nombreSala];
  return nombreSala == null
      ? null
      : Sala(nombre: nombreSala, host: sala!.host, jugadores: sala.jugadores);
});
