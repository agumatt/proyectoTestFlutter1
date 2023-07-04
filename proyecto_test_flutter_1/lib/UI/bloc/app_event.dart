import 'package:proyecto_test_flutter_1/Data/person_model.dart';

sealed class AppEvent {}

class PeopleListRequested extends AppEvent {}

class PersonCreatedOrUpdated extends AppEvent {
  final Persona persona;
  PersonCreatedOrUpdated(this.persona);
}

class UserModeSet extends AppEvent {
  final String usuario;
  UserModeSet(this.usuario);
}

class FreeModeSet extends AppEvent {}
