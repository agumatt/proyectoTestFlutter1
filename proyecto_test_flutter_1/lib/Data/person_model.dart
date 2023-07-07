import 'package:equatable/equatable.dart';
import 'package:proyecto_test_flutter_1/Misc/constants.dart';

class Persona extends Equatable {
  late final String usuario;
  late final String email;
  late final String sobreMi;
  final int avatarIndex;
  final List<String> relaciones; // lista de usuarios relacionados

  Persona({
    required String usuario,
    String email = '',
    String sobreMi = '',
    this.avatarIndex = 0,
    this.relaciones = const [],
  }) {
    this.usuario = usuario.trim();
    this.email = email.trim();
    this.sobreMi = sobreMi.trim();
    assert(!relaciones.contains(usuario));
    assert(0 <= avatarIndex && avatarIndex < Avatars.numberOfAvatars);
  }

  Persona copyWith({
    String? email,
    String? sobreMi,
    int? avatarIndex,
    List<String>? relaciones,
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
