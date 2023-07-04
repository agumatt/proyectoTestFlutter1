import 'package:equatable/equatable.dart';
import 'package:proyecto_test_flutter_1/Data/person_model.dart';

enum PeopleDataStatus { empty, loading, available }

enum AppMode { userMode, freeMode }

class AppState extends Equatable {
  final PeopleDataStatus status;
  final AppMode appMode;
  final String? usuario;
  final List<Persona> personas;

  AppState(this.status, this.appMode, this.personas, {this.usuario}) {
    if (appMode == AppMode.userMode) {
      assert(usuario != null);
    }
  }

  @override
  List<Object?> get props => [status, personas];
}
