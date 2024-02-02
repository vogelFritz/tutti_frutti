class Sala {
  String nombre;
  List<String> jugadores;

  Sala({required this.nombre, required this.jugadores});

  factory Sala.fromJson(Map<String, dynamic> json) {
    final List<String> auxList = [];
    for (String jug in json['jugadores']) {
      auxList.add(jug);
    }
    return Sala(nombre: json['nombre'], jugadores: auxList);
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'jugadores': jugadores,
      };
}
