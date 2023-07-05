import 'package:equatable/equatable.dart';
import 'package:proyecto_test_flutter_1/Data/person_model.dart';

enum PeopleDataStatus { empty, loading, available }

enum AppMode { userMode, freeMode }

extension AppModeExtension on AppMode {
  bool get isUserMode => this == AppMode.userMode;
  bool get isFreeMode => this == AppMode.freeMode;
}

extension PeopleDataStatusExtension on PeopleDataStatus {
  bool get isEmpty => this == PeopleDataStatus.empty;
  bool get isLoading => this == PeopleDataStatus.loading;
  bool get isAvailable => this == PeopleDataStatus.available;
}

class AppState extends Equatable {
  final PeopleDataStatus status;
  final AppMode appMode;
  final String? usuario;
  final List<Persona> personas;

  AppState(this.status, this.appMode, this.personas, {this.usuario}) {
    if (appMode.isUserMode) {
      assert(usuario != null);
    }
  }

  @override
  List<Object?> get props => [status, personas];
}
