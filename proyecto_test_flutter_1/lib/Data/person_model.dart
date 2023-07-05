import 'package:equatable/equatable.dart';

class Persona extends Equatable {
  final String usuario;
  final String email;
  final String sobreMi;
  final int avatarIndex;
  final List<String> relaciones; // lista de usuarios relacionados

  Persona({
    required this.usuario,
    this.email = '',
    this.sobreMi = '',
    this.avatarIndex = 0,
    this.relaciones = const [],
  }) {
    assert(!relaciones.contains(usuario));
    assert(0 <= avatarIndex && avatarIndex <= 4);
  }

  Persona copyWith({
    email,
    sobreMi,
    avatarIndex,
    relaciones,
  }) =>
      Persona(
          usuario: usuario,
          sobreMi: sobreMi ?? this.sobreMi,
          email: email ?? this.email,
          avatarIndex: avatarIndex ?? this.avatarIndex,
          relaciones: relaciones ?? this.relaciones);

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'email': email,
      'sobreMi': sobreMi,
      'avatarIndex': avatarIndex,
    };
  }

  static Persona fromJSON(
      Map<String, Object?> persona, List<String> relaciones) {
    assert(persona['usuario'] != null);
    return Persona(
        usuario: persona['usuario'] as String,
        email: (persona['email'] ?? '') as String,
        avatarIndex: (persona['avatarIndex'] ?? 0) as int,
        sobreMi: (persona['sobreMi'] ?? '') as String,
        relaciones: relaciones);
  }

  @override
  List<Object?> get props => [usuario, email, sobreMi, avatarIndex, relaciones];
}
