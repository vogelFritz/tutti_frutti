class User {
  String nombre;
  String? sala;
  bool ready;
  bool voted;
  int points;
  Map<String, FieldAnswer> fieldValues;

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
    Map<String, FieldAnswer>? fieldValues,
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

class FieldAnswer {
  final int points;
  final String answer;
  FieldAnswer({this.points = 5, required this.answer});
  factory FieldAnswer.fromJson(Map<String, dynamic> jsonMap) => FieldAnswer(
        answer: jsonMap['answer'],
        points: int.parse(jsonMap['points']),
      );

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'points': points.toString(),
      };

  FieldAnswer copyWith({
    String? answer,
    int? points,
  }) =>
      FieldAnswer(
        answer: answer ?? this.answer,
        points: points ?? this.points,
      );
}
