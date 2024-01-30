class Sala {
  String nombre;
  List<String> jugadores = [];

  Sala({required this.nombre});

  factory Sala.fromJson(Map<String, dynamic> json) =>
      Sala(nombre: json['nombre']);

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'jugadores': jugadores,
      };
}
