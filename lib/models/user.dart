class User {
  String nombre;
  String? sala;
  bool ready;
  bool voted;
  int points;
  Map<String, String> fieldValues;

  User({
    this.nombre = '',
    this.sala,
    this.ready = false,
    this.voted = false,
    this.points = 0,
    this.fieldValues = const {},
  });

  User copyWith({
    String? nombre,
    String? sala,
    bool? ready,
    bool? voted,
    int? points,
    Map<String, String>? fieldValues,
  }) =>
      User(
        nombre: nombre ?? this.nombre,
        sala: sala ?? this.sala,
        ready: ready ?? this.ready,
        voted: voted ?? this.voted,
        points: points ?? this.points,
        fieldValues: fieldValues ?? this.fieldValues,
      );

  factory User.fromJson(Map<String, dynamic> json) =>
      User(nombre: json['nombre']);
}
