import 'package:tutti_frutti/models/sala.dart';

class User {
  String nombre;
  Sala? sala;
  User({this.nombre = '', this.sala});

  User copyWith({
    String? nombre,
    Sala? sala,
  }) =>
      User(
        nombre: nombre ?? this.nombre,
        sala: sala ?? this.sala,
      );
}
