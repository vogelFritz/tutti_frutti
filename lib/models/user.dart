class User {
  String nombre;
  String? sala;
  bool ready;
  int points;
  User({this.nombre = '', this.sala, this.ready = false, this.points = 0});

  User copyWith({
    String? nombre,
    String? sala,
    bool? ready,
    int? points,
  }) =>
      User(
        nombre: nombre ?? this.nombre,
        sala: sala ?? this.sala,
        ready: ready ?? this.ready,
        points: points ?? this.points,
      );

  factory User.fromJson(Map<String, dynamic> json) =>
      User(nombre: json['nombre']);
}
