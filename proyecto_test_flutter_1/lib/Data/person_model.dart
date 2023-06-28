import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

class Persona extends Equatable {
  final String id;
  final String nombres;
  final String apellidos;
  final String email;
  final String sobreMi;
  final int avatarIndex;
  final List<String> relaciones; // lista de id's

  Persona({
    String? id,
    required this.nombres,
    required this.apellidos,
    this.email = '',
    this.sobreMi = '',
    this.avatarIndex = 0,
    this.relaciones = const [],
  }) : this.id = id ?? const Uuid().v4() {
    assert(!relaciones.contains(id));
    assert(0 <= avatarIndex && avatarIndex < 3);
  }

  Persona copyWith({
    nombres,
    apellidos,
    email,
    sobreMi,
    avatarIndex,
    relaciones,
  }) =>
      Persona(
          id: id,
          nombres: nombres ?? this.nombres,
          apellidos: apellidos ?? this.apellidos,
          sobreMi: sobreMi ?? this.sobreMi,
          email: email ?? this.email,
          avatarIndex: avatarIndex ?? this.avatarIndex,
          relaciones: relaciones ?? this.relaciones);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'sobreMi': sobreMi,
      'avatarIndex': avatarIndex,
    };
  }

  static Persona fromJSON(
      Map<String, Object?> persona, List<String> relaciones) {
    assert(persona['id'] != null);
    assert(persona['nombres'] != null);
    assert(persona['apellidos'] != null);
    return Persona(
        id: persona['id'] as String,
        nombres: persona['nombres'] as String,
        apellidos: persona['apellidos'] as String,
        email: (persona['email'] ?? '') as String,
        avatarIndex: (persona['avatarIndex'] ?? 0) as int,
        sobreMi: (persona['sobreMi'] ?? '') as String,
        relaciones: relaciones);
  }

  @override
  List<Object?> get props =>
      [id, nombres, apellidos, email, sobreMi, avatarIndex, relaciones];
}
