class CardRest {
  final String nombre;
  final String distancia;
  final List<String> urlImage;
  final String id;

  const CardRest({
    required this.nombre,
    required this.distancia,
    required this.urlImage,
    required this.id,
  });

  Map<String, dynamic> toJSON() => {
        'nombre': nombre,
        'distancia': distancia,
        'urlImage': urlImage,
        'id': id,
      };
}
