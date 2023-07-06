import 'package:equatable/equatable.dart';
import 'package:proyecto_test_flutter_1/Data/person_model.dart';

enum PeopleDataStatus { empty, loading, available }

enum AppMode { userMode, freeMode }

enum DBStatus { success, failure, unknown }

extension AppModeExtension on AppMode {
  bool get isUserMode => this == AppMode.userMode;
  bool get isFreeMode => this == AppMode.freeMode;
}

extension PeopleDataStatusExtension on PeopleDataStatus {
  bool get isEmpty => this == PeopleDataStatus.empty;
  bool get isLoading => this == PeopleDataStatus.loading;
  bool get isAvailable => this == PeopleDataStatus.available;
}

extension DBStatusExtension on DBStatus {
  bool get isSuccess => this == DBStatus.success;
  bool get isFailure => this == DBStatus.failure;
  bool get isUnknown => this == DBStatus.unknown;
}

class AppState extends Equatable {
  final PeopleDataStatus status;
  final AppMode appMode;
  final String? usuario;
  final List<Persona> personas;
  final DBStatus dbStatus; // al agregar o modificar personas

  AppState(this.status, this.appMode, this.personas,
      {this.usuario, this.dbStatus = DBStatus.unknown}) {
    if (appMode.isUserMode) {
      assert(usuario != null);
    }
  }

  Persona? get personaUsuario {
    if (appMode.isFreeMode || !status.isAvailable) {
      return null;
    }
    return personas.firstWhere((element) => element.usuario == usuario);
  }

  List<Persona>? get relacionesUsuario {
    if (appMode.isFreeMode || !status.isAvailable) {
      return null;
    }
    return personas
        .where(
            (element) => personaUsuario!.relaciones.contains(element.usuario))
        .toList();
  }

  @override
  List<Object?> get props => [status, personas, usuario, dbStatus, appMode];
}
