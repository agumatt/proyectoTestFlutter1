class Person {
  final String nombres;
  final String apellidos;
  final String email;
  final String sobreMi;
  final List<int> relaciones; // lista de id's

  Person({
    required this.nombres,
    required this.apellidos,
    this.email = '',
    this.sobreMi = '',
    this.relaciones = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'sobreMi': sobreMi,
    };
  }
}
