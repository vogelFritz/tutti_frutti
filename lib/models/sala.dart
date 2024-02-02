import 'package:tutti_frutti/models/user.dart';

class Sala {
  String nombre;
  User host;
  List<User> jugadores;

  Sala({required this.nombre, required this.host, required this.jugadores});

  bool get allReady => jugadores.every((jug) => jug.ready);

  factory Sala.fromJson(Map<String, dynamic> json) {
    final List<User> auxList = [];
    for (Map<String, dynamic> jug in json['jugadores']) {
      auxList.add(User.fromJson(jug));
    }
    return Sala(
        nombre: json['nombre'],
        host: User(nombre: json['host']),
        jugadores: auxList);
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'host': host.nombre,
        'jugadores': [
          ...jugadores.map((jug) => {
                'nombre': jug.nombre,
              })
        ],
      };
}
