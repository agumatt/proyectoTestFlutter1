import 'package:uuid/uuid.dart';

class Persona {
  final String id;
  final String nombres;
  final String apellidos;
  final String email;
  final String sobreMi;
  final List<String> relaciones; // lista de id's

  Persona({
    String? id,
    required this.nombres,
    required this.apellidos,
    this.email = '',
    this.sobreMi = '',
    this.relaciones = const [],
  }) : this.id = id ?? const Uuid().v4() {
    assert(!relaciones.contains(id));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'sobreMi': sobreMi,
    };
  }

  static Persona fromJSON(
      Map<String, String> persona, List<String> relaciones) {
    assert(persona['id'] != null);
    assert(persona['nombres'] != null);
    assert(persona['apellidos'] != null);
    return Persona(
        id: persona['id'] as String,
        nombres: persona['nombres'] as String,
        apellidos: persona['apellidos'] as String,
        email: persona['email'] ?? '',
        sobreMi: persona['sobreMi'] ?? '',
        relaciones: relaciones);
  }
}
